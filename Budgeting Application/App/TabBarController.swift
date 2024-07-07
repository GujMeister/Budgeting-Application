//
//  TabBarController.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)

        let recurringVC = RecurringViewController()
        recurringVC.tabBarItem = UITabBarItem(title: "Recurring", image: UIImage(systemName: "repeat"), tag: 1)
        
        let budgetsVC = BudgetsViewController()
        budgetsVC.tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(systemName: "book.closed"), tag: 2)

        let viewControllerList = [dashboardVC, recurringVC, budgetsVC]

        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            if let navController = viewControllers?[2] as? UINavigationController,
               let budgetsVC = navController.viewControllers.first as? BudgetsViewController {
                budgetsVC.shouldAnimateInfoView = selectedIndex != 2
            }
        }
    }
}

import SwiftUI
import UIKit

class RecurringViewController: UIHostingController<RecurringPage> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RecurringPage())
    }

    init() {
        super.init(rootView: RecurringPage())
    }
}
