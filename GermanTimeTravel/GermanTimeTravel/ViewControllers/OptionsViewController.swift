//
//  OptionsViewController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/15/21.
//

import UIKit

class OptionsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private var languageControl: UISegmentedControl!
    @IBOutlet private var unitControl: UISegmentedControl!
    
    // MARK: - Properties
    
    weak var controller: ModelController?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Actions
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
        let languageIndex = sender.selectedSegmentIndex
        if languageIndex == 0 {
            controller?.language = .english
        } else {
            controller?.language = .german
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(languageIndex, forKey: .language)
        languageAlert(languageIndex: languageIndex)
    }
    
    @IBAction func changeUnit(_ sender: UISegmentedControl) {
        let unitIndex = sender.selectedSegmentIndex
        if unitIndex == 0 {
            controller?.unit = .imperial
        } else {
            controller?.unit = .metric
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(unitIndex, forKey: .unit)
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        let language = UserDefaults.standard.integer(forKey: .language)
        languageControl.selectedSegmentIndex = language
        let unit = UserDefaults.standard.integer(forKey: .unit)
        unitControl.selectedSegmentIndex = unit
    }
    
    private func languageAlert(languageIndex: Int) {
        if let languageCode = Locale.current.languageCode {
            if languageCode == "de" && languageIndex == 0 {
                let alert = UIAlertController(title: nil, message: "Ändern der Sprache in der App beeinflusst ausschließlich die Sprache der Szenario- und Ereignistexte. Um die Sprache der Menüpunkte zu ändern, ändere die Sprache in den Systemeinstellungen deines iPhones.", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true)
            } else if languageCode != "de" && languageIndex == 1 {
                let alert = UIAlertController(title: nil, message: "Setting the language preference for this app will only change the Scenario and Event text. To view the app's labels and buttons in German, change your device's language preference to German.", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true)
            }
        }
    }

}

extension String {
    static let language = "language"
    static let unit = "unit"
}

