//
//  CustomNavController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/2/21.
//

import UIKit

class CustomNavController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
        
        
        

        // Do any additional setup after loading the view.
    }
    

}
