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
    @IBOutlet weak var unitsLabel: UILabel!
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
        unitsLabel.text = ""
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
        
        totalEventsLabel.text = "TOTAL EVENTS: \(scenario.totalEvents)"
        unitsLabel.text = "MAJOR EVENTS: \(scenario.majorEvents)"
        self.roundView.roundCorners(cornerRadius: 25)
    }
    
    @IBAction func moreInfoTapped(_ sender: UIButton) {
      
    }
    
    
}
