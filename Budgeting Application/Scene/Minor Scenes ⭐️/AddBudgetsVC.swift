//
//  AddCategoriesViewController.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import UIKit

protocol AddBudgetsDelegate: AnyObject {
    func addCategory(_ category: BasicExpenseCategory, totalAmount: Double)
    func checkForDuplicateCategory(_ category: BasicExpenseCategory) -> Bool
}

final class AddBudgetsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AddBudgetsDelegate?
    
    private var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 20)
        label.text = "Choose Budget Category"
        return label
    }()
    
    private let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "Input Budget Limit"
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. 1500"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var amountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .customBlue
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.inputAmountButtonTapped()
        }), for: .touchUpInside)

        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Budget", for: .normal)
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.addButtonTapped()
        }), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Regular", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customBlue
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let categories = BasicExpenseCategory.allCases
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addDoneButtonToKeyboards()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .customBackground
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let views = [topView, categoryLabel, categoryPicker, amountLabel, amountTextField, amountButton, addButton]
        
        views.forEach { singleView in
            view.addSubview(singleView)
            singleView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.heightAnchor.constraint(equalToConstant: 5),
            topView.widthAnchor.constraint(equalToConstant: 70),
            
            categoryLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            amountLabel.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 5),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 3),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: amountButton.leadingAnchor, constant: -20),
            
            amountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            amountButton.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),

            addButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 30),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Helper functions
    @objc private func addButtonTapped() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = categories[selectedCategoryIndex]
        
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            invalidInput()
            return
        }
        
        if let delegate = delegate, delegate.checkForDuplicateCategory(category) {
            showAlert(message: "Category already exists")
        } else {
            delegate?.addCategory(category, totalAmount: amount)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Keyboard Functions
    private func addDoneButtonToKeyboards() {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        doneToolbar.items = [flexSpace, doneButton]

        amountTextField.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonTapped() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Information Alerts
    private func inputAmountButtonTapped() {
        let alert = UIAlertController(title: "Info about the input amount", message: "This number will be used to set the amount that you are going to budget every month for this payment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func invalidInput() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please fill out all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddBudgetsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
}
