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
        controller.signInAndGetScenarioList()
    }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
