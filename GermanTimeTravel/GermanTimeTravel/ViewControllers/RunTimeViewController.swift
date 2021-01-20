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
    @IBOutlet weak var stackView: UIStackView!
    
    var days: Int = 0
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        setUpViews()
    }

    private func setUpViews() {
        gradient.frame = roundView.bounds
        roundView.layer.addSublayer(gradient)
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        roundView.roundCorners(cornerRadius: 25)
        roundView.bringSubviewToFront(stackView)
        roundView.bringSubviewToFront(startButton)
        
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient1 = CAGradientLayer()
        gradient1.type = .axial
        gradient1.colors = [
            UIColor(named: "LightBlue")?.cgColor,
            UIColor(named: "DarkBlue")?.cgColor
        ]
        gradient1.locations = [0, 1]
        return gradient1
    }()
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
