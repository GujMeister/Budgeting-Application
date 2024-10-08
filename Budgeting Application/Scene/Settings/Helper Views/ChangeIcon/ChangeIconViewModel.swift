//
//  ChangeIconViewModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import SwiftUI

final class ChangeIconViewModel: ObservableObject {
    // MARK: - Properties
    @Published var icons: [String] = [
        "Default Dark Mode",
        "Green Dark Mode",
        "Green Icon",
        "Orange Icon",
        "Purple Dark Mode",
        "Purple Icon"
    ]
    @Published var currentIcon: String? = nil
    
    // MARK: - Init
    init() {
        fetchCurrentIcon()
    }
    
    // MARK: - Helper Functions
    func fetchCurrentIcon() {
        currentIcon = UIApplication.shared.alternateIconName
    }
    
    func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else { return }

        UIApplication.shared.setAlternateIconName(iconName) { [weak self] error in
            if let error = error {
                print("Error changing app icon: \(error.localizedDescription)")
            } else {
                self?.currentIcon = iconName
            }
            print("Icon Updated")
        }
    }
    
    func resetIcon() {
        changeAppIcon(to: nil)
    }
}
