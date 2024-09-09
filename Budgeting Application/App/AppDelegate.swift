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
    var window: UIWindow?
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Use for testing
//        DataDeletion.shared.deleteAllKeychainData()
//        DataDeletion.shared.deleteCoreData()
//        DataDeletion.shared.deleteUserDefaults()
        return true
    }
}
