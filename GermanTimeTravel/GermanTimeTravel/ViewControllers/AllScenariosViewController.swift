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
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

}

extension AllScenariosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller?.summaries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scenarioCell", for: indexPath) as! ScenarioTableViewCell
        cell.scenario = controller?.summaries?[indexPath.row]
        return cell
    }
}
