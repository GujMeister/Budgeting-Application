//
//  SceneDelegate.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootViewController = InitialViewController()
        
///     `Use for testing`
///      let rootViewController = MainTabBarController()
        
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()

    }

    func switchToMainTabBar() {
        let mainTabBarController = MainTabBarController()
        window?.rootViewController = mainTabBarController
    }
    
    func switchToLoginView() {
        let rootView = LoginView(viewModel: LoginPageViewModel())
        let hostingController = UIHostingController(rootView: rootView)
        window?.rootViewController = hostingController
    }
}
