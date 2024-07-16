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
        
        let viewControllerList = [dashboardVC, recurringVC, budgetsVC, calendarVC]
        
        viewControllers = viewControllerList.map {
            let navController = UINavigationController(rootViewController: $0)
            navController.navigationBar.prefersLargeTitles = true
            return navController
        }
    }
    
    private func setupCustomTabBar() {
        tabBar.configureMaterialBackground(
            selectedItemColor: .red,
            unselectedItemColor: .white,
            blurStyle: .prominent
        )
        self.tabBar.backgroundColor = .customBlue
    }
//    
//    func changeUnSelectedColor(){
//        self.tabBar.unselectedItemTintColor = .white
//        self.tabBar.tintColor = .red //Selected Item Color
//     }
    
    func ChangeRadiusOfTabbar(){
     self.tabBar.layer.masksToBounds = true
     self.tabBar.isTranslucent = true
     self.tabBar.layer.cornerRadius = 30
     self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
 
    }
}

// Helper extension for Int to CGFloat conversion
private extension Int {
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
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

public extension UITabBar {
    func configureMaterialBackground(
        selectedItemColor: UIColor = .systemBlue,
        unselectedItemColor: UIColor = .secondaryLabel,
        blurStyle: UIBlurEffect.Style = .regular
    ) {
        // Make tabBar fully tranparent
        isTranslucent = true
        backgroundImage = UIImage()
        shadowImage = UIImage() // no separator
        barTintColor = .clear
        layer.backgroundColor = UIColor.clear.cgColor
    
        // Apply icon colors
        tintColor = selectedItemColor
        unselectedItemTintColor = unselectedItemColor
    
        // Add material blur
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurView, at: 0)
    }
}
