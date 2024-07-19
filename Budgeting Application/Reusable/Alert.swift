//
//  Alert.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import UIKit

func presentAlert(from presentingViewController: UIViewController,
                  title: String,
                  message: String,
                  actions: [UIAlertAction] = []) {

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    if actions.isEmpty {
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
    } else {
        actions.forEach { alertController.addAction($0) }
    }

    // Find appropriate view controller for presentation (iOS 13+ compatible)
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
           
           var currentViewController = rootViewController
           while let presentedVC = currentViewController.presentedViewController {
               currentViewController = presentedVC
           }
           
           currentViewController.present(alertController, animated: true)
    }
}

func presentAlert(title: String, message: String) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
        var currentViewController = rootViewController
        while let presentedVC = currentViewController.presentedViewController {
            currentViewController = presentedVC
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        currentViewController.present(alertController, animated: true)
    }
}
