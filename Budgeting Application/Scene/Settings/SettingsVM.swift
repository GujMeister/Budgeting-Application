//
//  SettingsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

import SwiftUI

class SettingsVM: ObservableObject {
    @AppStorage("userName") var userName: String = ""
    
    private var viewModel = BudgetsViewModel()
    
    @Published var showChangePasswordView = false
    @Published var showChangeNameView = false
    @Published var showChangeIcon = false
    @Published var showAboutView = false
    @Published var alert: UIAlertController?

    func deleteBasicExpenses() {
        confirmDeletion { [weak self] in
            DataManager.shared.deleteBasicExpenses()
            self?.viewModel.loadFavoritedBudgets()
            self?.viewModel.loadExpenses()
            self?.viewModel.loadBudgets()
            self?.viewModel.filterExpenses()
        }
    }

    func deleteSubscriptionExpenses() {
        confirmDeletion {
            DataManager.shared.deleteSubscriptionExpenses()
        }
    }

    func deletePaymentExpenses() {
        confirmDeletion {
            DataManager.shared.deletePaymentExpenses()
        }
    }

    func deleteAllData() {
        confirmDeletion {
            DataManager.shared.deleteAllRecords()
        }
    }

    private func confirmDeletion(action: @escaping () -> Void) {
        // Create the alert
        let alert = UIAlertController(title: "Confirm Deletion",
                                      message: "Are you sure you want to delete this data? This action cannot be undone.",
                                      preferredStyle: .alert)

        // Delete Action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            action() // Perform the deletion
        })

        // Cancel Action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // Assign alert to the published variable
        self.alert = alert
    }
}


import SwiftUI
import UIKit

struct SwiftUIViewController: UIViewControllerRepresentable {
    var alert: UIAlertController?

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let alert = alert, uiViewController.presentedViewController == nil {
            uiViewController.present(alert, animated: true)
        }
    }
}
