//
//  LoginViewModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 12.07.24.
//

import Foundation
//import Security
//import Combine

class LoginPageViewModel: ObservableObject {
    @Published var temporaryPasscode: String = ""

    var isPasscodeSet: Bool {
        return retrievePasscode() != nil
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
