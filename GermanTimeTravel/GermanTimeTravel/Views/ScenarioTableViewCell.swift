//
//  ScenarioTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class ScenarioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalEventsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    var scenario: Summary? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        totalEventsLabel.text = ""
        language = nil
        scenario = nil
    }
    
    private func updateViews() {
        guard let scenario = scenario else { return }
        if language == .english {
            titleLabel.text = scenario.nameEn
            descriptionLabel.text = scenario.descriptionEn
        } else {
            titleLabel.text = scenario.nameDe
            descriptionLabel.text = scenario.descriptionDe
        }
        totalEventsLabel.text = "\(scenario.totalEvents) events      \(scenario.majorEvents) major events"
        self.roundView.roundCorners(cornerRadius: 25)
    }
    

}
