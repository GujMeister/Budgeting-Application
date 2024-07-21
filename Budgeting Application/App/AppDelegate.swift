//
//  AppDelegate.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let container = NSPersistentContainer(name: "Model")

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        DataManager.shared.deleteAllRecords()
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
//        deleteAllKeychainData()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainTabBarController = MainTabBarController()

        window.rootViewController = mainTabBarController
        self.window = window
        window.makeKeyAndVisible()

        return true
    }
    
    private func deleteAllKeychainData() {
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
}
