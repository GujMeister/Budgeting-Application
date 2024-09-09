//
//  ChangeLanguagesViewModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 31.08.24.
//

import SwiftUI

class ChangeLanguagesViewModel: ObservableObject {
    @AppStorage("LocalizeDefaultLanguage") var language: String = "en" {
        didSet {
            UserDefaults.standard.setValue(language, forKey: "LocalizeDefaultLanguage")
        }
    }

    func setLanguage(_ lang: String) {
        language = lang
    }

    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
