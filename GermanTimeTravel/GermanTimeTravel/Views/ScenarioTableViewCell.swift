//
//  ScenarioTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

protocol LabelDelegate: AnyObject {
    func didChangeLabelHeight()
}

class ScenarioTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var totalEventsLabel: UILabel!
    @IBOutlet private var unitsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    // MARK: Properties
    
    var scenario: Summary? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    weak var delegate: LabelDelegate?
    
    // MARK: - Actions
    
    @IBAction func moreInfoTapped(_ sender: UIButton) {
        if descriptionLabel.numberOfLines == 3 {
            descriptionLabel.numberOfLines = 0
        } else {
            descriptionLabel.numberOfLines = 3
        }
        delegate?.didChangeLabelHeight()
    }
    
    // MARK: Private Functions
    
    private func updateViews() {
        guard let scenario = scenario else { return }
        if language == .english {
            titleLabel.text = scenario.nameEn
            descriptionLabel.text = scenario.descriptionEn
            totalEventsLabel.text = "Events: \(scenario.totalEvents)"
            unitsLabel.text = "Major Events: \(scenario.majorEvents)"
        } else {
            titleLabel.text = scenario.nameDe
            descriptionLabel.text = scenario.descriptionDe
            totalEventsLabel.text = "Ereignisse: \(scenario.totalEvents)"
            unitsLabel.text = "Zentrale Ereignisse: \(scenario.majorEvents)"
        }
        self.roundView.roundCorners(cornerRadius: 15)
    }
    
}
