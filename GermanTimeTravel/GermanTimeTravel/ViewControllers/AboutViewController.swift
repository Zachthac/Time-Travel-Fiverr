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
    @IBOutlet weak var imprintButton: UIButton!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    
    @IBAction func imprintButtonTapped(_ sender: Any) {
        if controller?.language == .english {
            let alert = UIAlertController(title: "Imprint", message: "Nikos Sauer\nMeinekestraße 2\n10719 Berlin, Germany\n\nContact: timetranslator-info@gmx.de", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Impressum", message: "Nikos Sauer\nMeinekestraße 2\n10719 Berlin\n\nE-Mail: timetranslator-info@gmx.de", preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true)
        }
    }
}
