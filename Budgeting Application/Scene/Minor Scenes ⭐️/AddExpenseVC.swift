//
//  AddExpenseVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit

protocol AddExpenseDelegate: AnyObject {
    func didAddExpense(_ expense: BasicExpenseModel)
    func updateBudgets(_ expense: BasicExpenseModel)
}

class AddExpenseViewController: UIViewController {
    
    weak var delegate: AddExpenseDelegate?
    
    private let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date() // Prevent selecting future dates
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Expense", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categories = BasicExpenseCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [categoryPicker, descriptionTextField, amountTextField, datePicker, addButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func addButtonTapped() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = categories[selectedCategoryIndex]
        
        guard let description = descriptionTextField.text, !description.isEmpty,
              let amountText = amountTextField.text, let amount = Double(amountText) else {
            // Handle invalid input
            return
        }
        
        let context = DataManager.shared.context
        let expense = BasicExpenseModel(context: context)
        expense.category = category.rawValue
        expense.expenseDescription = description
        expense.amount = NSNumber(value: amount)
        expense.date = datePicker.date
        
        let expenseService = BasicExpenseService(context: context)
        expenseService.addExpense(expense)
        
        delegate?.didAddExpense(expense)
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
