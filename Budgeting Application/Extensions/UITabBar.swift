//
//  UITabBar.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import UIKit

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
