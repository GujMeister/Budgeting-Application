//
//  LaunchScreenVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

import SwiftUI

final class InitialViewController: UIViewController {
    // MARK: - Properties
    private let budgetoLabel: UILabel = {
        let label = UILabel()
        label.text = "Budgeto."
        label.font = UIFont.systemFont(ofSize: 142, weight: .bold)
        label.textColor = .infoViewColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBudgetoLabel()
        animateBudgetoLabel()
    }

    // MARK: - Helper functions
    private func setupBudgetoLabel() {
        view.backgroundColor = .backgroundColor
        view.addSubview(budgetoLabel)
        NSLayoutConstraint.activate([
            budgetoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            budgetoLabel.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
    }

    private func animateBudgetoLabel() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 1.5, animations: {
            self.budgetoLabel.frame.origin.x = -1700
        }) { _ in
            self.showInitialView()
        }
    }

    private func showInitialView() {
        let hasSeenOnBoarding = UserDefaults.standard.bool(forKey: "hasSeenOnBoarding")
        let rootView: AnyView

        if hasSeenOnBoarding {
            rootView = AnyView(LoginView(viewModel: LoginPageViewModel()))
        } else {
            rootView = AnyView(OnBoarding())
        }

        let hostingController = UIHostingController(rootView: rootView)
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true, completion: nil)
    }
}
