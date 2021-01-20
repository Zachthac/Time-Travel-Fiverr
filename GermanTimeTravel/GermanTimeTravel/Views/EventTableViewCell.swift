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
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    var unit: Unit?
    
    private func updateViews() {
        guard let event = event else { return }
        if language == .english {
            eventDetailsLabel.text = event.textEn
        } else {
            eventDetailsLabel.text = event.textDe
        }
        if let time = event.startDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
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
