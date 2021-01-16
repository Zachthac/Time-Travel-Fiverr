//
//  ScenarioTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class ScenarioTableViewCell: UITableViewCell {
    @IBOutlet weak var scenarioTitleLabel: UILabel!
    @IBOutlet weak var scenarioDetailsLabel: UILabel!
    @IBOutlet weak var scenarioUnitEventsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
