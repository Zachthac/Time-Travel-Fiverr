//
//  ModelController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/14/21.
//

import UIKit
import CoreData
import NotificationCenter

enum Language {
    case english
    case german
}

enum Unit {
    case imperial
    case metric
}

protocol ScenarioDelegate: AnyObject {
    func summariesUpdated()
}

class ModelController {
    
    // MARK: - Properties
    
    let api = ApiController()
    let moc = CoreDataStack.shared.mainContext
    var summaries: [Summary]? {
        didSet {
            delegate?.summariesUpdated()
        }
    }
    var language: Language = .english
    var unit: Unit = .imperial
    private let cache = Cache<String, UIImage>()
    weak var delegate: ScenarioDelegate?
    let notificationPublisher = NotificationPublisher()
    
    // MARK: - Public Functions
    
    /// called in MainViewController to fetch preferences from UserDefaults
    func setPreferences() {
        let languageIndex = UserDefaults.standard.integer(forKey: .language)
        if languageIndex == 0 {
            language = .english
        } else {
            language = .german
        }
        let unitIndex = UserDefaults.standard.integer(forKey: .unit)
        if unitIndex == 0 {
            unit = .imperial
        } else {
            unit = .metric
        }
    }
    
    /// uses api.signIn to get a bearer token, then uses api.fetchSummaries to populate self.summaries
    /// to be called in AllScenariosViewController to populate tableView
    func signInAndGetScenarioList() {
        api.signIn { result in
            switch result {
            case .success:
                self.api.fetchSummaries { summaryResult in
                    switch summaryResult {
                    case .success(let summaries):
                        self.summaries = summaries
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }
    
    /// called when the user selects a Scenario to experience, creates an instance of Active to track progress
    /// - Parameters:
    ///   - nameId: accepts a nameId
    ///   - totalTime: accepts a total time, expressed as a Double in seconds
    ///   - completion: returns a Bool for use in configuring UI alerts and functionality
    func startScenario(nameId: String, totalTime: Double, completion: @escaping (Bool) -> Void) {
        api.fetchScenario(nameID: nameId) { result in
            switch result {
            case .success(let scenario):
                self.preloadImages(scenario: scenario)
                let displayRatio = totalTime / (scenario.endDouble - scenario.startDouble)
                Active(totalTime: totalTime, displayRatio: displayRatio, scenario: scenario)
                if let events = scenario.events {
                    let start = scenario.startDouble
                    let eventArray = Array(events) as! [Event]
                    for event in eventArray {
                        event.displayTiming = (event.startDouble - start) * displayRatio
                        if event.major == true {
                            self.sendNotification(scenario: scenario, event: event)
                        }
                    }
                }
                let saveResult = self.saveMOC()
                completion(saveResult)
            default:
                completion(false)
            }
        }
    }
    
    
    /// called to update event status while a scenario is active
    /// if time elapsed is greater than each events start time, event.displayed is updated to True
    /// - Parameter scenario: accepts the active scenario
    /// - Parameter completion: completion provides a Bool, representing scenarioStillRunning
    func updateEventStatus(scenario: Scenario, completion: (Bool) -> Void) {
        guard let startTime = scenario.active?.startTime?.timeIntervalSince1970,
              let totalTime = scenario.active?.totalTime,
              let events = scenario.events,
              let eventArray = Array(events) as? [Event] else {
            completion(false)
            return
        }
        
        let timeElapsed = Date().timeIntervalSince1970 - startTime
        if timeElapsed > totalTime {
            for event in eventArray {
                event.displayed = true
            }
            saveMOC()
            completion(false)
            return
        }
        
        for event in eventArray {
            if timeElapsed > event.displayTiming {
                event.displayed = true
            }
        }
        saveMOC()
        completion(true)
    }
    
    /// called to update elapsed time while a scenario is active
    /// - Parameters:
    ///   - scenario: accepts the active scenario
    ///   - completion: completion provides a dictionary [Bool: Double]
    ///     the Bool represents scenarioStillRunning, and the Double is time elapsed
    func updateTime(scenario: Scenario, completion: ([Bool: Double]) -> Void) {
        guard let startTime = scenario.active?.startTime?.timeIntervalSince1970,
              let totalTime = scenario.active?.totalTime else {
            completion([false: 0])
            return
        }
        let timeElapsed = Date().timeIntervalSince1970 - startTime
        if timeElapsed > totalTime {
            completion([false: totalTime])
            return
        }
        completion([true: timeElapsed])
    }
    
    /// called when the user finishes experiencing a scenario
    /// automatically deletes the Active object and all Events associated with the scenario through CoreData's delete rules
    /// clears the image cache
    /// - Parameter scenario: accepts a scenario to be deleted
    func endScenario(scenario: Scenario, completion: @escaping (Bool) -> Void) {
        moc.delete(scenario)
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        cache.clear()
        let result = saveMOC()
        completion(result)
    }
    
    /// checks the image cache before making a network call to fetch an image
    /// saves a newly fetched image in the cache
    /// - Parameters:
    ///   - summary: use a Summary for loading the image in RunTimeViewController, else set to nil
    ///   - scenario: use a Scenario for loading images everywhere except RunTimeViewController, where it is set to nil
    ///   - event: Optional - accepts an event, use if image is not the main Scenario image
    ///   - completion: completion provides a UIImage, or nil if no image is available for that scenario or event
    func loadImage(summary: Summary?, scenario: Scenario?, event: Event?, completion: @escaping (UIImage?) -> Void) {
        var imageReference = ""
        var image: UIImage?
        
        if let summary = summary {
            guard let imageName = summary.image else {
                completion(nil)
                return
            }
            imageReference = imageName
        }
        if let event = event {
            guard let imageName = event.image else {
                completion(nil)
                return
            }
            imageReference = imageName
        } else if summary == nil {
            guard let imageName = scenario?.image else {
                completion(nil)
                return
            }
            imageReference = imageName
        }
        
        if let cachedImage = cache.value(for: imageReference) {
            completion(cachedImage)
            return
        }
        self.api.fetchImage(summary: summary, scenario: scenario, event: event) { result in
            switch result {
            case .success(let fetchedImage):
                self.cache.cache(value: fetchedImage, for: imageReference)
                image = fetchedImage
                completion(image)
                return
            default:
                completion(nil)
                return
            }
        }
    }
    
    /// called when a scenario is started to load images for all events into the cache for smoother performance
    /// - Parameter scenario: accepts a scenario
    func preloadImages(scenario: Scenario) {
        let bgQueue = DispatchQueue(label: "bgQueue")
        bgQueue.async {
            guard let eventSet = scenario.events,
                  let events = Array(eventSet) as? [Event] else { return }
            for event in events {
                self.loadImage(summary: nil, scenario: scenario, event: event) { _ in
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    /// a helper function for saving changes to CoreData objects
    /// called in ModelController functions wherever objects are created, deleted or edited
    /// - Returns: returns a Bool
    @discardableResult private func saveMOC() -> Bool {
        do {
            try moc.save()
            return true
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
            return false
        }
    }
    
    /// called in startScenario to set up local notifications for major events
    /// - Parameters:
    ///   - scenario: accepts a Scenario
    ///   - event: accepts an Event
    private func sendNotification(scenario: Scenario, event: Event) {
        var subtitleText = ""
        var bodyText = ""
        if language == .english {
            subtitleText = scenario.nameEn!
            bodyText = event.textEn!
        } else {
            subtitleText = scenario.nameDe!
            bodyText = event.textDe!
        }
        notificationPublisher.sendNotification(title: "Time Translator",
                                               subtitle: subtitleText,
                                               body: bodyText,
                                               badge: 1,
                                               delayInterval: event.displayTiming)
    }
    
}
