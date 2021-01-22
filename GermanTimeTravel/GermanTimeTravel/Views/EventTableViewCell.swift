//
//  EventTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var currentUnitLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    var unit: Unit?
    
    override func prepareForReuse() {
        roundView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func updateViews() {
        
        selectedBackgroundView?.backgroundColor = UIColor.darkYellow

        guard let event = event else { return }
        if language == .english {
            eventDetailsLabel.text = event.textEn
        } else {
            eventDetailsLabel.text = event.textDe
        }
        if let time = event.startDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            if event.scenario?.unit == "datetime" {
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                formatter.timeStyle = .short
            }
            currentUnitLabel.text = formatter.string(from: time)
        } else {
            if unit == .imperial {
                currentUnitLabel.text = String("\(event.startDouble) million miles")
            } else {
                currentUnitLabel.text = String("\(event.startDouble * 1.609344) million kilometers")
            }
        }
    }

}
