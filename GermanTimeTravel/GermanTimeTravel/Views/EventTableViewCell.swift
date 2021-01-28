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
    @IBOutlet weak var cameraImageView: UIImageView!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    var unit: Unit?
    
    private func updateViews() {
        
        guard let event = event else { return }
        if event.image != nil {
            cameraImageView.tintColor = UIColor.darkYellow
        } else {
            cameraImageView.tintColor = UIColor.clear
        }
        
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
                if language == .english {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 92.955807)) million miles")
                } else {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 92.955807)) millionen meilen")
                }
            } else {
                if language == .english {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 149.597871)) million kilometers")
                } else {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 149.597871)) millionen kilometer")
                }
            }
        }
    }
    
}
