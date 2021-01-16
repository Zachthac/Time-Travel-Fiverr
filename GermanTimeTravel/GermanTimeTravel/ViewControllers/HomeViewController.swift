//
//  MainViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/3/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    let controller = ModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.setPreferences()
        controller.signInAndGetScenarioList()
    }
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scenarioListSegue" {
            let allScenariosVC = segue.destination as! AllScenariosViewController
            allScenariosVC.controller = controller
        }
    }

}
