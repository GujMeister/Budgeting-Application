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
        return true
    }
    
    // MARK: - Use for testing
//    DataDeletion.shared.deleteAllKeychainData()
//    DataDeletion.shared.deleteCoreData()
//    DataDeletion.shared.deleteUserDefaults()
    
}
