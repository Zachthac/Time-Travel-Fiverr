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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let scenario = scenario else { return }
        titleLabel.text = scenario.nameEn
        descriptionLabel.text = scenario.descriptionEn
        totalEventsLabel.text = "\(scenario.totalEvents) events"
        self.roundView.roundCorners(cornerRadius: 25)
    }
    

}
