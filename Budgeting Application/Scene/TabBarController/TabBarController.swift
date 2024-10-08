//
//  TabBarController.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 01.07.24.
//

import SwiftUI

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
        ChangeRadiusOfTabbar()
    }
    
    // MARK: - Setup Tab Bar Views
    private func setupViewControllers() {
        let dashboardViewModel = DashboardViewModel()
        let dashboardVC = DashboardViewController(viewModel: dashboardViewModel)
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let recurringVC = RecurringViewController()
        recurringVC.tabBarItem = UITabBarItem(title: "Recurring", image: UIImage(systemName: "repeat"), tag: 1)
        
        let budgetsViewModel = BudgetsViewModel()
        let budgetsVC = BudgetsViewController(viewModel: budgetsViewModel)
        budgetsVC.tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(systemName: "book.closed"), tag: 2)
        
        let calendarViewModel = CalendarViewModel()
        let calendarVC = CalendarViewController(viewModel: calendarViewModel)
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 3)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        let viewControllerList = [dashboardVC, recurringVC, budgetsVC, calendarVC, settingsVC]
        
        viewControllers = viewControllerList.map {
            let navController = UINavigationController(rootViewController: $0)
            navController.navigationBar.prefersLargeTitles = true
            return navController
        }
    }
    
    // MARK: - Custom Tab Bar Functions
    private func setupCustomTabBar() {
        tabBar.configureMaterialBackground(
            selectedItemColor: .primaryTextColor,
            unselectedItemColor: .gray,
            blurStyle: .prominent
        )
        self.tabBar.backgroundColor = .backgroundColor
    }
    
    private func ChangeRadiusOfTabbar(){
     self.tabBar.layer.masksToBounds = true
     self.tabBar.isTranslucent = true
     self.tabBar.layer.cornerRadius = 10
     self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - SwiftUI to UIKit
final class RecurringViewController: UIHostingController<RecurringPage> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RecurringPage())
    }
    
    init() {
        super.init(rootView: RecurringPage())
    }
}

final class SettingsViewController: UIHostingController<SettingsView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsView())
    }
    
    init() {
        super.init(rootView: SettingsView())
    }
}
