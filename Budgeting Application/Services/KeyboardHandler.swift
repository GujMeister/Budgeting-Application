//
//  Keyboard Functions.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 18.07.24.
//

import UIKit

final class KeyboardHandler {
    private weak var viewController: UIViewController?
    private var keyboardHeight: CGFloat = 0

    init(viewController: UIViewController) {
        self.viewController = viewController

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardHeight = keyboardSize.height

        if viewController?.view.frame.origin.y == 0 {
            viewController?.view.frame.origin.y -= keyboardHeight * 0.5
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if viewController?.view.frame.origin.y != 0 {
            viewController?.view.frame.origin.y = 0
        }
        keyboardHeight = 0
    }

    func addDoneButtonToKeyboard(for textFields: [UITextField]) {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        doneToolbar.items = [flexSpace, doneButton]

        textFields.forEach { $0.inputAccessoryView = doneToolbar }
    }

    @objc private func doneButtonTapped() {
        viewController?.view.endEditing(true)
    }
}
