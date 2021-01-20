//
//  AllScenariosViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/15/20.
//

import UIKit
import Foundation


class AllScenariosViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak var roundView: UIView!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpViews()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runTimeSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let summaries = controller?.summaries else { return }
            let runTimeVC = segue.destination as! RunTimeViewController
            runTimeVC.controller = controller
            runTimeVC.scenario = summaries[indexPath.row]
        }
    }
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        gradient1.frame = roundView.bounds
        gradient2.frame = titleView.bounds
        titleView.layer.addSublayer(gradient2)
        titleView.bringSubviewToFront(titleLabel)
        roundView.layer.addSublayer(gradient1)
        roundView.roundCorners(cornerRadius: 25)
        tableView.roundCorners(cornerRadius: 25)
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
    
}

extension AllScenariosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller?.summaries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scenarioCell", for: indexPath) as! ScenarioTableViewCell
        cell.language = controller?.language
        cell.scenario = controller?.summaries?[indexPath.row]
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
}
