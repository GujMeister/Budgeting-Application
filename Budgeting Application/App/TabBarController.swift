//
//  TabBarController.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dashboardViewModel = DashboardViewModel()
        let dashboardVC = DashboardViewController(viewModel: dashboardViewModel)
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        
        let recurringVC = RecurringViewController()
        recurringVC.tabBarItem = UITabBarItem(title: "Recurring", image: UIImage(systemName: "repeat"), tag: 1)
        
        let budgetsVC = BudgetsViewController()
        budgetsVC.tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(systemName: "book.closed"), tag: 2)
        
        let viewControllerList = [dashboardVC, recurringVC, budgetsVC]
        
        viewControllers = viewControllerList.map {
            let navController = UINavigationController(rootViewController: $0)
            // Set delegate for navigation controllers
//            navController.delegate = self // Important!
            return navController
        }
    }
    
}
// MARK: - SwiftUI to UIKit
class RecurringViewController: UIHostingController<RecurringPage> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RecurringPage())
    }
    
    init() {
        super.init(rootView: RecurringPage())
    }
}
//
//// MARK: - UINavigationControllerDelegate
//extension MainTabBarController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if let budgetsVC = viewController as? BudgetsViewController {
//            budgetsVC = navigationController.viewControllers.count == 1
//        }
//    }
//}
