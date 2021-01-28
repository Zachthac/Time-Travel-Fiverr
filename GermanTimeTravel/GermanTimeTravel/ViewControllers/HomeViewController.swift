//
//  MainViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/3/20.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    let controller = ModelController()
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var activeScenario: Scenario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.setPreferences()
        controller.signInAndGetScenarioList()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest: NSFetchRequest<Scenario> = Scenario.fetchRequest()
        do {
            let scenarios = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            guard let scenario = scenarios.first,
                  scenario.active != nil else { return }
            activeScenario = scenario
            self.performSegue(withIdentifier: "activeScenarioSegue", sender: self)
        } catch {
            NSLog("No active scenario")
        }
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
            UIColor.lightBlue.cgColor,
            UIColor.darkBlue.cgColor
        ]
        gradient1.locations = [0, 1]
        return gradient1
    }()
    lazy var gradient2: CAGradientLayer = {
        let gradient2 = CAGradientLayer()
        gradient2.type = .radial
        gradient2.colors = [
            UIColor.lightBlue.cgColor,
            UIColor.darkBlue.cgColor
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
        } else if segue.identifier == "activeScenarioSegue" {
            let runScenarioVC = segue.destination as! RunScenarioViewController
            runScenarioVC.controller = controller
            runScenarioVC.scenario = activeScenario
        } else if segue.identifier == "optionsSegue" {
            let optionsVC = segue.destination as! OptionsViewController
            optionsVC.controller = controller
        } else if segue.identifier == "aboutSegue" {
            let aboutVC = segue.destination as! AboutViewController
            aboutVC.controller = controller
        }
    }

}
