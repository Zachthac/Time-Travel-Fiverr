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

}

extension String {
    static let language = "language"
    static let unit = "unit"
}

