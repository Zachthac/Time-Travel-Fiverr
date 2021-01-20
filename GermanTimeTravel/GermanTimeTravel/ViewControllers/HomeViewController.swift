//
//  MainViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/3/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    let controller = ModelController()
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.setPreferences()
        controller.signInAndGetScenarioList()
        setUpViews()
    }
    
    private func setUpViews() {
        gradient1.frame = roundView.bounds
        gradient2.frame = titleView.bounds
        roundView.layer.addSublayer(gradient1)
        titleView.layer.addSublayer(gradient2)
        titleView.bringSubviewToFront(titleLabel)
        roundView.roundCorners(cornerRadius: 25)
        roundView.bringSubviewToFront(stackView)
        
        
    }
    
    lazy var gradient1: CAGradientLayer = {
        let gradient1 = CAGradientLayer()
        gradient1.type = .axial
        gradient1.colors = [
            UIColor(named: "LightBlue")?.cgColor,
            UIColor(named: "DarkBlue")?.cgColor
        ]
        gradient1.locations = [0, 1]
        return gradient1
    }()
    lazy var gradient2: CAGradientLayer = {
        let gradient2 = CAGradientLayer()
        gradient2.type = .radial
        gradient2.colors = [
            UIColor(named: "LightBlue")?.cgColor,
            UIColor(named: "DarkBlue")?.cgColor
        ]
        gradient2.startPoint = CGPoint(x: 0.5, y: 0.75)
        let endY = 1 + view.frame.size.width / view.frame.size.height
        gradient2.endPoint = CGPoint(x: 1.1, y: endY)
            return gradient2
    }()
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scenarioListSegue" {
            let allScenariosVC = segue.destination as! AllScenariosViewController
            allScenariosVC.controller = controller
        }
    }

}
