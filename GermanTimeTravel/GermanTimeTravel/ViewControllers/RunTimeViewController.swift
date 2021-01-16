//
//  EnterRunTimeViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/2/21.
//

import UIKit

class RunTimeViewController: UIViewController {

    @IBOutlet weak var scenarioTitleLabel: UILabel!
    @IBOutlet weak var scenarioImage: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var days: Int = 0
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        setUpViews()
    }

    private func setUpViews() {
        self.pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        self.roundView.roundCorners(cornerRadius: 25)
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = roundView.bounds
//        gradientLayer.colors = [UIColor(named: "DarkBlue"), UIColor(named: "LightBlue")]
//        gradientLayer.startPoint = CGPoint(x: 0.5,y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        roundView.layer.addSublayer(gradientLayer)
    }
    
}

extension RunTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 100
        case 1:
            return 23
        case 2:
            return 60
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        case 3:
            return "\(row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            days = row
        case 1:
            hours = row
        case 2:
            minutes = row
        case 3:
            seconds = row
        default:
            break;
        }
    }
}


extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    

}
