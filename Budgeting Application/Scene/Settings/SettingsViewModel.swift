//
//  SettingsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

import SwiftUI

final class SettingsVM: ObservableObject {
    // MARK: - Properties
    @AppStorage("userName") var userName: String = ""
    @Published var showChangePasswordView = false
    @Published var showChangeNameView = false
    @Published var showChangeIcon = false
    @Published var showAboutView = false
    @Published var showChangeLanguage = false
    @Published var alert: UIAlertController?
    private var viewModel = BudgetsViewModel()

    func deleteBasicExpenses() {
        confirmDeletion { [weak self] in
            DataManager.shared.deleteBasicExpenses()
            self?.viewModel.loadData()
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
            DataDeletion.shared.deleteUserDefaults()
            DataDeletion.shared.deleteCoreData()
        }
    }

    private func confirmDeletion(action: @escaping () -> Void) {
        let alert = UIAlertController(title: "Confirm Deletion",
                                      message: "Are you sure you want to delete this data? This action cannot be undone.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            action()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.alert = alert
    }
}

// MARK: - Alert in SwiftUI
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
