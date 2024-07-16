//
//  LaunchScreenVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

//import UIKit
import SwiftUI

class InitialViewController: UIViewController {
    // MARK: - Properties
    private let budgetoLabel: UILabel = {
        let label = UILabel()
        label.text = "Budgeto."
        label.font = UIFont.systemFont(ofSize: 162, weight: .bold) // Adjust font size and weight as needed
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightsLabel: UILabel = {
        let label = UILabel()
        label.text = "© All Rights Reserved"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Set your desired background color
        setupBudgetoLabel()
        animateBudgetoLabel()
    }

    private func setupBudgetoLabel() {
        view.addSubview(budgetoLabel)
        NSLayoutConstraint.activate([
            budgetoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            budgetoLabel.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
    }

    private func animateBudgetoLabel() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 2.0, animations: {
            self.budgetoLabel.frame.origin.x = -1700
        }) { _ in
            self.showLoginView()
        }
    }

    private func showLoginView() {
        let hostingController = UIHostingController(rootView: LoginView(viewModel: LoginPageViewModel()))
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true, completion: nil)
    }
}
