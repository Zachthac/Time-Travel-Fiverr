//
//  EventTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var currentUnitLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    weak var unitHelper: UnitHelper?
    
    // MARK: - Private Functions
    
    private func updateViews() {
        
        guard let event = event else { return }
        if event.image != nil {
            cameraImageView.tintColor = UIColor.darkYellow
        } else {
            cameraImageView.tintColor = UIColor.clear
        }
        
        if unitHelper?.language == .english {
            eventDetailsLabel.text = event.textEn
        } else {
            eventDetailsLabel.text = event.textDe
        }
        currentUnitLabel.text = unitHelper?.eventCellLabel(date: event.startDate, double: event.startDouble)
    }
    
}
