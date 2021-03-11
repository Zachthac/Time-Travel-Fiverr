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
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var eventImage: UIImageView!
    @IBOutlet private var eventsTableView: UITableView!
    @IBOutlet private var timePassedLabel: UILabel!
    @IBOutlet private var currentEventDateLabel: UILabel!
    @IBOutlet private var photoImageView: UIView!
    @IBOutlet private var noPhotoLabel: UILabel!
    @IBOutlet private var imageInfoButton: UIButton!
    @IBOutlet private var cancelButton: UIButton!
        
    // MARK: - Properties
    
    weak var controller: ModelController?
    var scenario: Scenario?
    private var datasource: UITableViewDiffableDataSource<Int, Event>!
    private var fetchedResultsController: NSFetchedResultsController<Event>!
    private let moc = CoreDataStack.shared.mainContext
    var unitHelper: UnitHelper?

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
    
    override func viewDidLayoutSubviews() {
        setUpGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.eventImage.image == nil {
                self.controller?.loadImage(summary: nil, scenario: self.scenario, event: nil, completion: { image in
                    DispatchQueue.main.async {
                        self.eventImage.image = image
                    }
                })
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelScenario(_ sender: UIButton) {
        if self.controller?.language == .english {
            let alert = UIAlertController(title: "Quit Scenario?", message: nil, preferredStyle: .alert)
            let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(noButton)
            let yesButton = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.quitScenario()
            }
            alert.addAction(yesButton)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Szenario beenden?", message: nil, preferredStyle: .alert)
            let noButton = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
            alert.addAction(noButton)
            let yesButton = UIAlertAction(title: "Beenden", style: .destructive) { _ in
                self.quitScenario()
            }
            alert.addAction(yesButton)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        guard let event = selectedEvent else { return }
        if event.image != nil {
            let alert = UIAlertController(title: event.license, message: event.source, preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Private Functions
    
    private func setUpGradient() {
        gradient.frame = photoImageView.bounds
        photoImageView.layer.addSublayer(gradient)
        photoImageView.bringSubviewToFront(noPhotoLabel)
        photoImageView.bringSubviewToFront(eventImage)
        photoImageView.bringSubviewToFront(imageInfoButton)
        photoImageView.bringSubviewToFront(cancelButton)
    }
    
    private func setUpViews() {
        cancelButton.tintAdjustmentMode = .normal
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
        guard let unitType = scenario.unit,
              let language = controller?.language,
              let unit = controller?.unit else { return }
        unitHelper = UnitHelper(unitType: unitType, language: language, unit: unit)
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
            cell.unitHelper = self.unitHelper
            cell.event = event
            return cell
        })
        eventsTableView.dataSource = datasource
    }
    
    private func initFetchedResultsController() {
        guard let scenario = scenario,
              let startTime = scenario.active?.startTime else { return }
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        if startTime.timeIntervalSince1970 > Date().timeIntervalSince1970 {
            fetchRequest.predicate = NSPredicate(format: "scenario == %@ AND index == %i", scenario, 0)
        } else {
            fetchRequest.predicate = NSPredicate(format: "scenario == %@ AND displayed == %d", scenario, true)
        }
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
                guard let start = scenario.active?.startTime?.timeIntervalSince1970,
                    start < Date().timeIntervalSince1970 else { return }
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
        guard let timer = timer else { return }
        RunLoop.main.add(timer, forMode: .common)
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
                            self.selectedEvent = self.fetchedResultsController.fetchedObjects?.last
                        }
                    })
                    self.cancelButtonAnimation()
                    if self.controller?.language == .english {
                        let alert = UIAlertController(title: "Finished!", message: "Use the cancel button to clear this scenario.", preferredStyle: .alert)
                        let button = UIAlertAction(title: "OK", style: .cancel) { _ in
                            UIView.animate(withDuration: 1) {
                                self.cancelButton.tintColor = .systemRed
                            }
                        }
                        alert.addAction(button)
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Fertig!", message: "Nutze den Abbrechen-Button, um das Szenario zu beenden.", preferredStyle: .alert)
                        let button = UIAlertAction(title: "OK", style: .cancel) { _ in
                            UIView.animate(withDuration: 1) {
                                self.cancelButton.tintColor = .systemRed
                            }
                        }
                        alert.addAction(button)
                        self.present(alert, animated: true)
                    }
                }
            })
        })
        guard let eventTimer = eventTimer else { return }
        RunLoop.main.add(eventTimer, forMode: .common)
    }
    
    private func currentDateString(timeElapsed: Double) -> String {
        guard let scenario = scenario,
              let ratio = scenario.active?.displayRatio,
              let unitHelper = unitHelper else { return "" }
        let timeDouble = scenario.startDouble + (timeElapsed / ratio)
        return unitHelper.timePassedLabel(double: timeDouble)
    }
    
    private func endDateString() -> String {
        guard let scenario = scenario,
              let unitHelper = unitHelper else { return "" }
        return unitHelper.timePassedLabel(double: scenario.endDouble)
    }
    
    private func updateViews() {
        guard let scenario = scenario else { return }
        let eventIndex = ((fetchedResultsController.fetchedObjects?.count ?? 1) - 1)
        guard eventIndex >= 0 else { return }
        for index in 0...eventIndex {
            if let imageString = fetchedResultsController.fetchedObjects?[index].image {
                if currentImage == imageString {
                    return
                } else {
                    let event = fetchedResultsController.fetchedObjects?[index]
                    controller?.loadImage(summary: nil, scenario: scenario, event: event, completion: { image in
                        DispatchQueue.main.async {
                            self.imageInfoButton.tintColor = UIColor.darkYellow
                            self.eventImage.image = image
                            self.currentImage = imageString
                            self.selectedEvent = event
                            let cells = self.eventsTableView.visibleCells as! [EventTableViewCell]
                            for cell in cells {
                                if cell.event?.image == self.currentImage {
                                    cell.roundView.layer.borderColor = UIColor.darkYellow.cgColor
                                } else {
                                    cell.roundView.layer.borderColor = UIColor.clear.cgColor
                                }
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
    
    private func startAnimation() {
        guard let scenario = scenario,
           let start = scenario.active?.startTime?.timeIntervalSince1970,
           start > Date().timeIntervalSince1970 else { return }
        let countdown = UILabel()
        countdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdown)
        countdown.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.bounds.height * 0.18)).isActive = true
        countdown.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countdown.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .bold)
        countdown.textColor = UIColor.darkYellow
        countdown.text = ""
        countdown.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            countdown.alpha = 1
        }) { (_) in
            countdown.text = "Ready..."
            countdown.alpha = 1
            UIView.animate(withDuration: 1, animations: {
                countdown.alpha = 0
            }) { (_) in
                countdown.text = "Set..."
                countdown.alpha = 1
                UIView.animate(withDuration: 1, animations: {
                    countdown.alpha = 0
                }) { (_) in
                    countdown.text = "Go!"
                    countdown.alpha = 1
                    UIView.animate(withDuration: 1) {
                        countdown.alpha = 0
                    } completion: { (_) in
                        countdown.removeFromSuperview()
                        self.initFetchedResultsController()
                    }
                }
            }
        }
    }
    
    private func cancelButtonAnimation() {
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        cancelButton.setImage(image, for: .normal)
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse]) {
            self.cancelButton.tintColor = .darkYellow
        } completion: { _ in }
    }
    
    private func quitScenario() {
        guard let scenario = scenario else { return }
        controller?.endScenario(scenario: scenario, completion: { result in
            switch result {
            case true:
                self.timer?.invalidate()
                self.eventTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
            case false:
                if self.controller?.language == .english {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong - please try again.", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(button)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Fehler", message: "Es ist etwas schief gegangen - Bitte versuche es erneut.", preferredStyle: .alert)
                    let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(button)
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        eventTimer?.invalidate()
        eventTimer = nil
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.lightBlue.cgColor,
            UIColor.darkBlue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.75)
        let endY = 1 + view.frame.size.width / view.frame.size.height
        gradient.endPoint = CGPoint(x: 1.1, y: endY)
            return gradient
    }()
    
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
        let cells = self.eventsTableView.visibleCells as! [EventTableViewCell]
        for cell in cells {
            cell.roundView.layer.borderColor = UIColor.clear.cgColor
        }
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        cell.roundView.layer.borderColor = UIColor.darkYellow.cgColor
        let event = cell.event
        selectedEvent = event
        eventsTableView.deselectRow(at: indexPath, animated: false)
        if event?.image != nil {
            controller?.loadImage(summary: nil, scenario: scenario, event: event, completion: { image in
                DispatchQueue.main.async {
                    self.eventImage.image = image
                    self.imageInfoButton.tintColor = UIColor.darkYellow
                }
            })
        } else {
            eventImage.image = nil
            self.imageInfoButton.tintColor = .clear
        }
    }

}
