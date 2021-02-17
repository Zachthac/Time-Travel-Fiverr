//
//  TutorialViewController.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 2/17/21.
//

import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var previousButton: UIButton!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var currentPage: Int = 0
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.isHidden = true
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if currentPage < tutorial.count {
            currentPage += 1
        }
        if currentPage >= 1 {
            previousButton.isHidden = false
        }
        if tutorial.count == currentPage {
            alertWhenDone()
        }
        animateAndUpdateViews()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        currentPage -= 1
        if currentPage == 0 {
            previousButton.isHidden = true
        }
        animateAndUpdateViews()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func animateAndUpdateViews() {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
            self.textLabel.alpha = 0
        }) { (_) in
            self.updateViews()
            UIView.animate(withDuration: 0.5) {
                self.imageView.alpha = 1
                self.textLabel.alpha = 1
            }
        }
    }
    
    private func updateViews() {
        imageView.image = tutorial[currentPage].image
        if controller?.language == .english {
            textLabel.text = tutorial[currentPage].textEn
        } else {
            textLabel.text = tutorial[currentPage].textDe
        }
    }
    
    private func alertWhenDone() {
        if controller?.language == .english {
            let alert = UIAlertController(title: "Tutorial Finished!", message: nil, preferredStyle: .alert)
            let backButton = UIAlertAction(title: "Go Back", style: .cancel, handler: nil)
            let doneButton = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(backButton)
            alert.addAction(doneButton)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Tutorial Fertig!", message: nil, preferredStyle: .alert)
            let backButton = UIAlertAction(title: "Zurück", style: .cancel, handler: nil)
            let doneButton = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(backButton)
            alert.addAction(doneButton)
            self.present(alert, animated: true)
        }
    }

}
