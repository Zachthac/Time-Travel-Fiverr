//
//  RunScenarioViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit
import CoreData

class RunScenarioViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var currentEventDateLabel: UILabel!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var scenario: Scenario?
    private var datasource: UITableViewDiffableDataSource<Int, Event>!
    private var fetchedResultsController: NSFetchedResultsController<Event>!
    private let moc = CoreDataStack.shared.mainContext

    var timer: Timer?
    var eventTimer: Timer?
    var selectedEvent: Event?
    var currentImage: String = ""
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        eventsTableView.delegate = self
        eventsTableView.allowsMultipleSelection = false
        configureDatasource()
        initFetchedResultsController()
        setUpTimer()
        setUpEventTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelScenario(_ sender: UIBarButtonItem) {
        guard let scenario = scenario else { return }
        controller?.endScenario(scenario: scenario, completion: { result in
            switch result {
            case true:
                self.timer?.invalidate()
                self.eventTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
            case false:
                let alert = UIAlertController(title: "Error", message: "Something went wrong - please try again.", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true)
            }
        })
    }
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        timePassedLabel.text = ""
        currentEventDateLabel.text = ""
        timePassedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timePassedLabel.font.pointSize, weight: .medium)
        currentEventDateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: currentEventDateLabel.font.pointSize, weight: .medium)
        guard let scenario = scenario else { return }
        if controller?.language == .english {
            titleLabel.text = scenario.nameEn
        } else {
            titleLabel.text = scenario.nameDe
        }
        controller?.loadImage(summary: nil, scenario: scenario, event: nil, completion: { image in
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        })
    }
    
    private func configureDatasource() {
        datasource = UITableViewDiffableDataSource(tableView: eventsTableView, cellProvider: { (tableView, indexPath, event) -> UITableViewCell? in
            guard let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Cannot create cell") }
            cell.roundView.layer.borderWidth = 3
            if event == self.selectedEvent {
                cell.roundView.layer.borderColor = UIColor.darkYellow.cgColor
            } else {
                cell.roundView.layer.borderColor = UIColor.clear.cgColor
            }
            cell.language = self.controller?.language
            cell.unit = self.controller?.unit
            cell.event = event
            return cell
        })
        eventsTableView.dataSource = datasource
    }
    
    private func initFetchedResultsController() {
        guard let scenario = scenario else { return }
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDouble", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "scenario == %@ AND displayed == %d", scenario, true)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Unable to fetch events from main context: \(error)")
        }
    }
    
    private func setUpTimer() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        guard let scenario = scenario else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.controller?.updateTime(scenario: scenario, completion: { result in
                if let time = result[true] {
                    let timeString = self.timeString(timeElapsed: time)
                    self.timePassedLabel.text = timeString
                    self.currentEventDateLabel.text = self.currentDateString(timeElapsed: time)
                } else if let time = result[false] {
                    self.timer?.invalidate()
                    let timeString = self.timeString(timeElapsed: time)
                    self.timePassedLabel.text = timeString
                    self.currentEventDateLabel.text = self.endDateString()
                }
            })
        })
    }
    
    private func setUpEventTimer() {
        guard let scenario = scenario else { return }
        eventTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            self.controller?.updateEventStatus(scenario: scenario, completion: { result in
                if result == true {
                    self.updateViews()
                } else {
                    self.eventTimer?.invalidate()
                    self.controller?.loadImage(summary: nil, scenario: scenario, event: nil, completion: { image in
                        DispatchQueue.main.async {
                            self.eventImage.image = image
                        }
                    })
                    let alert = UIAlertController(title: "Finished!", message: "Use the cancel button to clear this scenario.", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(button)
                    self.present(alert, animated: true)
                }
            })
        })
    }
    
    private func currentDateString(timeElapsed: Double) -> String {
        guard let scenario = scenario,
              let ratio = scenario.active?.displayRatio else { return "" }
        let timeDouble = scenario.startDouble + (timeElapsed / ratio)
        if scenario.unit == "date" {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: Date(timeIntervalSince1970: timeDouble))
        } else if scenario.unit == "datetime" {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.timeStyle = .short
            return formatter.string(from: Date(timeIntervalSince1970: timeDouble))
        } else {
            if controller?.unit == .imperial {
                return String("\(Int(timeDouble * 92.955807)) M m")
            } else {
                return String("\(Int(timeDouble * 149.597871)) M km")
            }
        }
    }
    
    private func endDateString() -> String {
        guard let scenario = scenario else { return "" }
        if let time = scenario.endDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if scenario.unit == "datetime" {
                formatter.dateStyle = .none
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                formatter.timeStyle = .short
            }
            return formatter.string(from: time)
        } else {
            if controller?.unit == .imperial {
                return String("\(Int(scenario.endDouble * 92.955807)) M m")
            } else {
                return String("\(Int(scenario.endDouble * 149.597871)) M km")
            }
        }
    }
    
    private func updateViews() {
        guard let scenario = scenario else { return }
        let eventIndex = ((fetchedResultsController.fetchedObjects?.count ?? 1) - 1)
        for index in 0...eventIndex {
            if let imageString = fetchedResultsController.fetchedObjects?[index].image {
                if currentImage == imageString {
                    return
                } else {
                    let event = fetchedResultsController.fetchedObjects?[index]
                    controller?.loadImage(summary: nil, scenario: scenario, event: event, completion: { image in
                        DispatchQueue.main.async {
                            self.eventImage.image = image
                            self.currentImage = imageString
                            self.selectedEvent = nil
                            let cells = self.eventsTableView.visibleCells as! [EventTableViewCell]
                            for cell in cells {
                                cell.roundView.layer.borderColor = UIColor.clear.cgColor
                            }
                        }
                    })
                    return
                }
            }
        }
    }
    
    private func timeString(timeElapsed: Double) -> String {
        let days = Int(floor(timeElapsed / 86400))
        var timeLeft = timeElapsed - (Double(days) * 86400)
        let hours = Int(floor(timeLeft / 3600))
        timeLeft = timeLeft - (Double(hours) * 3600)
        let minutes = Int(floor(timeLeft / 60))
        timeLeft = timeLeft - (Double(minutes) * 60)
        let seconds = Int(floor(timeLeft))
        
        var string = ""
        if days > 0 {
            string += "\(days):"
        }
        
        if hours > 9 {
            string += "\(hours):"
        } else if hours > 0 {
            string += "0\(hours):"
        }
        
        if minutes > 9 {
            string += "\(minutes):"
        } else if minutes > 0 {
            string += "0\(minutes):"
        } else {
            string += "00:"
        }
        
        if seconds > 9 {
            string += "\(seconds)"
        } else if seconds > 0 {
            string += "0\(seconds)"
        } else {
            string += "00"
        }
        return string
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        eventTimer?.invalidate()
        eventTimer = nil
    }
    
}

extension RunScenarioViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Event>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        datasource?.apply(diffableDataSourceSnapshot, animatingDifferences: view.window != nil)
    }
}

extension RunScenarioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        let event = cell.event
        if let imageName = event?.image,
           let cachedImage = controller?.cache.value(for: imageName) {
            cell.roundView.layer.borderColor = UIColor.darkYellow.cgColor
            selectedEvent = event
            eventImage.image = cachedImage
        } else {
            if let cachedImage = controller?.cache.value(for: currentImage) {
                eventImage.image = cachedImage
                selectedEvent = nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell {
            cell.roundView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
