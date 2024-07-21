//
//  LoginViewModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 12.07.24.
//

import Foundation

final class LoginPageViewModel: ObservableObject {
    // MARK: - Properties
    @Published var temporaryPasscode: String = ""
    @Published var topPasswordText: String = "Welcome"
    @Published var bottomPasswordText: String = "Create your 4-digit PIN to access your personal budgeting application"

    var isPasscodeSet: Bool {
        return retrievePasscode() != nil
    }

    // MARK: - Methods
    func setupTexts(userName: String) {
        topPasswordText = "Welcome back \(userName)"
        bottomPasswordText = "Enter your 4-digit PIN to log in to your personal budgeting application"
    }

    func handlePasscodeEntry(_ enteredPasscode: String, resetPasscode: @escaping () -> Void, switchToMainTabBar: @escaping () -> Void, presentAlert: @escaping (String, String) -> Void) {
        if !isPasscodeSet {
            if temporaryPasscode.isEmpty {
                temporaryPasscode = enteredPasscode
                topPasswordText = "Confirm Passcode"
                bottomPasswordText = "Repeat Your Passcode"
                resetPasscode()
            } else {
                if temporaryPasscode == enteredPasscode {
                    setPasscode(enteredPasscode)
                    switchToMainTabBar()
                } else {
                    temporaryPasscode = ""
                    topPasswordText = "Enter Passcode"
                    presentAlert("Error", "Passcodes do not match.")
                    resetPasscode()
                }
            }
        } else {
            if isPasscodeCorrect(enteredPasscode) {
                switchToMainTabBar()
            } else {
                presentAlert("Try Again", "Incorrect passcode.")
                resetPasscode()
            }
        }
    }

    func setPasscode(_ passcode: String) {
        storePasscode(passcode)
    }

    func isPasscodeCorrect(_ passcode: String) -> Bool {
        return retrievePasscode() == passcode
    }

    private func storePasscode(_ passcode: String) {
        guard let data = passcode.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yvelazeMagariKompania.ge.Budgeting-Application",
            kSecAttrAccount as String: "userPasscode",
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func retrievePasscode() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yvelazeMagariKompania.ge.Budgeting-Application",
            kSecAttrAccount as String: "userPasscode",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let data = dataTypeRef as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
