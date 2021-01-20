//
//  RunScenarioViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class RunScenarioViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var scenario: Scenario?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelScenario(_ sender: UIButton) {
        guard let scenario = scenario else { return }
        controller?.endScenario(scenario: scenario)
    }
    
    // MARK: - Private Functions
    
    private func updateViews(event: Event) {
        guard let scenario = scenario else { return }
        if controller?.language == .english {
            detailsLabel.text = event.textEn
        } else {
            detailsLabel.text = event.textDe
        }
        if let image = controller?.loadImage(scenario: scenario, event: event) {
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        }
    }
    
    private func setUpViews() {
        guard let scenario = scenario else { return }
        if controller?.language == .english {
            titleLabel.text = scenario.nameEn
            detailsLabel.text = scenario.descriptionEn
        } else {
            titleLabel.text = scenario.nameDe
            detailsLabel.text = scenario.descriptionDe
        }
        if let image = controller?.loadImage(scenario: scenario, event: nil) {
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        }
    }

}
