//
//  AboutViewController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/28/21.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet private var aboutLabel: UILabel!
    
    weak var controller: ModelController?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        if controller?.language == .english {
            aboutLabel.text = "Imprint\n\nNikos Sauer\nMeinekestraße 2\n10719 Berlin, Germany\n\nContact: timetranslator-info@gmx.de"
        } else {
            aboutLabel.text = "Impressum\n\nNikos Sauer\nMeinekestraße 2\n10719 Berlin\n\nE-Mail: timetranslator-info@gmx.de"
        }
    }

}
