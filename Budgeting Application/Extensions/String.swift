//
//  String.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 31.08.24.
//

import Foundation

extension String {
    func translated() -> String {
        let language = UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en"
        
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return NSLocalizedString(self, comment: "")
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
