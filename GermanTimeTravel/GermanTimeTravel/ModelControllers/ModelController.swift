//
//  ModelController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/14/21.
//

import UIKit
import CoreData

class ModelController {
    
    let api = ApiController()
    let moc = CoreDataStack.shared.mainContext
    var summaries: [Summary]?
    private let cache = Cache<String, UIImage>()
    
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
                Active(totalTime: totalTime, scenario: scenario)
                let saveResult = self.saveMOC()
                completion(saveResult)
            default:
                completion(false)
            }
        }
    }
    
    /// called when the user finishes experiencing a scenario
    /// automatically deletes the Active object and all Events associated with the scenario through CoreData's delete rules
    /// clears the image cache
    /// - Parameter scenario: accepts a scenario to be deleted
    func endScenario(scenario: Scenario) {
        moc.delete(scenario)
        cache.clear()
        saveMOC()
    }
    
    /// checks the image cache before making a network call to fetch an image
    /// saves a newly fetched image in the cache
    /// - Parameters:
    ///   - scenario: accepts a scenario
    ///   - event: Optional - accepts an event, event is nil if image is the main image for a scenario
    /// - Returns: returns UIImage, or nil if no image was available
    func loadImage(scenario: Scenario, event: Event?) -> UIImage? {
        var imageReference: String
        var image: UIImage?
        
        if let event = event {
            guard let imageName = event.image else { return nil }
            imageReference = imageName
        } else {
            guard let imageName = scenario.image else { return nil }
            imageReference = imageName
        }
        
        if let cachedImage = cache.value(for: imageReference) {
            return cachedImage
        }
        
        api.fetchImage(scenario: scenario, event: event) { result in
            switch result {
            case .success(let fetchedImage):
                self.cache.cache(value: fetchedImage, for: imageReference)
                image = fetchedImage
            default:
                break
            }
        }
        return image
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
    
}
