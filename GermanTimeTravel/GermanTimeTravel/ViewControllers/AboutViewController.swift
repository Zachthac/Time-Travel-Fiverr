//
//  AboutViewController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/28/21.
//

import UIKit

class AboutViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var aboutLabel: UILabel!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        if controller?.language == .english {
            aboutLabel.text = "Imprint\n\nNikos Sauer\nMeinekestraße 2\n10719 Berlin, Germany\n\nContact: timetranslator-info@gmx.de"
        } else {
            aboutLabel.text = "Impressum\n\nNikos Sauer\nMeinekestraße 2\n10719 Berlin\n\nE-Mail: timetranslator-info@gmx.de"
        }
    }

}
