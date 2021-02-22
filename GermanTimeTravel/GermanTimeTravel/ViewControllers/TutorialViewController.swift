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
    @IBOutlet private var roundView: UIView!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var currentPage: Int = 0
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        previousButton.isEnabled = false
        previousButton.backgroundColor = .clear
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if currentPage == tutorial.count - 1   {
                    alertWhenDone()
                }
        if currentPage < tutorial.count - 1  {
            currentPage += 1
            animateAndUpdateViews()
        }
        
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        currentPage -= 1
        animateAndUpdateViews()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func animateAndUpdateViews() {
        UIView.animate(withDuration: 0.5, animations: {
            self.textLabel.alpha = 0
            self.imageView.alpha = 0
        }) { (_) in
            self.updateViews()
            UIView.animate(withDuration: 0.5) {
                self.textLabel.alpha = 1
                self.imageView.alpha = 1

            }
        }
    }
    
    private func updateViews() {
        if currentPage > 0 {
            previousButton.isEnabled = true
            previousButton.backgroundColor = .darkYellow
        } else {
            previousButton.isEnabled = false
            previousButton.backgroundColor = .clear
        }
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
            let alert = UIAlertController(title: "Tutorial beendet!", message: nil, preferredStyle: .alert)
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
