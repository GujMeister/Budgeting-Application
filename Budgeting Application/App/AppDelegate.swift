//
//  AppDelegate.swift
//  PersonalFinanceV2
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
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainTabBarController = MainTabBarController()

        window.rootViewController = mainTabBarController
        self.window = window
        window.makeKeyAndVisible()

        return true
    }
}


