//
//  TabBarController.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

//import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
        ChangeRadiusOfTabbar()
    }
    
    private func setupViewControllers() {
        let dashboardViewModel = DashboardViewModel()
        let dashboardVC = DashboardViewController(viewModel: dashboardViewModel)
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        
        let recurringVC = RecurringViewController()
        recurringVC.tabBarItem = UITabBarItem(title: "Recurring", image: UIImage(systemName: "repeat"), tag: 1)
        
        let budgetsViewModel = BudgetsViewModel()
        let budgetsVC = BudgetsViewController(viewModel: budgetsViewModel)
        budgetsVC.tabBarItem = UITabBarItem(title: "Budgets", image: UIImage(systemName: "book.closed"), tag: 2)
        
        let calendarVC = CalendarViewController()
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
    
    private func setupCustomTabBar() {
        tabBar.configureMaterialBackground(
            selectedItemColor: .black,
            unselectedItemColor: .gray,
            blurStyle: .prominent
        )
        self.tabBar.backgroundColor = .white
    }
    
    private func ChangeRadiusOfTabbar(){
     self.tabBar.layer.masksToBounds = true
     self.tabBar.isTranslucent = true
     self.tabBar.layer.cornerRadius = 10
     self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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

class SettingsViewController: UIHostingController<SettingsView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsView())
    }
    
    init() {
        super.init(rootView: SettingsView())
    }
}
