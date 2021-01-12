//
//  EnterRunTimeViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/2/21.
//

import UIKit

class RunTimeViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.setValue(UIColor.white, forKeyPath: "textColor")

        // Do any additional setup after loading the view.
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
