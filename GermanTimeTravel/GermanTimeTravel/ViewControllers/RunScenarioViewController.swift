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
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var scenario: Scenario?
    private var datasource: UITableViewDiffableDataSource<Int, Event>!
    private var fetchedResultsController: NSFetchedResultsController<Event>!
    private let moc = CoreDataStack.shared.mainContext
    var timer: Timer?
    var currentEvent: Event?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        eventsTableView.delegate = self
        configureDatasource()
        initFetchedResultsController()
        setUpTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelScenario(_ sender: UIButton) {
        guard let scenario = scenario else { return }
        controller?.endScenario(scenario: scenario, completion: { result in
            switch result {
            case true:
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
        guard let scenario = scenario else { return }
        if controller?.language == .english {
            titleLabel.text = scenario.nameEn
        } else {
            titleLabel.text = scenario.nameDe
        }
        if let image = controller?.loadImage(scenario: scenario, event: nil) {
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        }
    }
    
    private func configureDatasource() {
        datasource = UITableViewDiffableDataSource(tableView: eventsTableView, cellProvider: { (tableView, indexPath, event) -> UITableViewCell? in
            guard let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Cannot create cell") }
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
        guard let scenario = scenario else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.controller?.updateEventStatus(scenario: scenario, completion: { result in
                if let time = result[true] {
                    self.updateViews()
                    let timeString = self.timeString(timeElapsed: time)
                    print(timeString)
                } else if let time = result[false] {
                    self.timer?.invalidate()
                    self.setUpViews()
                    let timeString = self.timeString(timeElapsed: time)
                    print(timeString)
                    let alert = UIAlertController(title: "Finished!", message: "Use the cancel button to clear this scenario.", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(button)
                    self.present(alert, animated: true)
                }
            })
        })
    }
    
    private func updateViews() {
        guard let scenario = scenario,
              let currentEvent = currentEvent else { return }
        if currentEvent.image != nil {
            let image = controller?.loadImage(scenario: scenario, event: currentEvent)
            DispatchQueue.main.async {
                self.eventImage.image = image
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
    }

}

extension RunScenarioViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Event>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        currentEvent = fetchedResultsController.fetchedObjects?.first
        datasource?.apply(diffableDataSourceSnapshot, animatingDifferences: view.window != nil)
    }
}

extension RunScenarioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scenario = scenario else { return }
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        let event = cell.event
        if let image = controller?.loadImage(scenario: scenario, event: event) {
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        }
    }
}
