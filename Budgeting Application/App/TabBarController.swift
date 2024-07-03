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

        let viewControllerList = [dashboardVC, recurringVC]

        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
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
