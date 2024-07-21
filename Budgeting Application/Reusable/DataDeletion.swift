//
//  DataDeletion.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 21.07.24.
//

import Foundation

final class DataDeletion {
    
    static let shared = DataDeletion()
    
    private init() {}
    
    internal func deleteAllKeychainData() {
        let service = "com.yvelazeMagariKompania.ge.Budgeting-Application"
        let account = "userPasscode"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Successfully deleted keychain item.")
        } else {
            print("Failed to delete keychain item with error: \(status)")
        }
    }
    
    internal func deleteCoreData() {
        DataManager.shared.deleteAllRecords()
    }
    
    internal func deleteUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}
