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

class AddBudgetsViewController: UIViewController {
    
    weak var delegate: AddBudgetsDelegate?
    
    // Your UI elements and other properties here
    
    private var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Budget", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categories = BasicExpenseCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(categoryPicker)
        view.addSubview(amountTextField)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            amountTextField.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func addButtonTapped() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedCategoryIndex]
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            // Show an alert for invalid amount
            showAlert(message: "Please enter a valid amount")
            return
        }
        
        if let delegate = delegate, delegate.checkForDuplicateCategory(selectedCategory) {
            // Show an alert for duplicate category
            showAlert(message: "Category already exists")
        } else {
            delegate?.addCategory(selectedCategory, totalAmount: amount)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
