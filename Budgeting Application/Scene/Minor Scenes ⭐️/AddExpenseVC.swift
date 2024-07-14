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

final class AddExpenseViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AddExpenseDelegate?
    
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
        label.text = "Choose Expense Category" // Changed text
        return label
    }()
    
    private let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "Input Expense Description" // Changed text
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. Groceries" // Changed placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .customBlue
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.descriptionsButtonTapped()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "Input Amount"
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g. 50" // Changed placeholder
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
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Expense", for: .normal) // Changed text
        
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

        let views = [topView, categoryLabel, categoryPicker, descriptionLabel, descriptionTextField, descriptionButton, amountLabel, amountTextField, amountButton, datePicker, addButton]
        
        views.forEach { singleView in
            view.addSubview(singleView)
            singleView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.heightAnchor.constraint(equalToConstant: 5),
            topView.widthAnchor.constraint(equalToConstant: 70),
            
            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionButton.leadingAnchor, constant: -20),
            
            descriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionButton.centerYAnchor.constraint(equalTo: descriptionTextField.centerYAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 15),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 3),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            amountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            amountButton.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: amountButton.leadingAnchor, constant: -20),

            datePicker.topAnchor.constraint(equalTo: amountButton.bottomAnchor, constant: 30),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            addButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Helper functions
    private func addButtonTapped() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = categories[selectedCategoryIndex]
        
        guard let description = descriptionTextField.text, !description.isEmpty,
              let amountText = amountTextField.text?.replacingOccurrences(of: ",", with: "."), let amount = Double(amountText) else {
            invalidInput()
            return
        }
        
        let context = DataManager.shared.context
        let expense = BasicExpenseModel(context: context)
        
        expense.category = category.rawValue
        expense.expenseDescription = description
        expense.amount = amount as NSNumber
        expense.date = datePicker.date
        
        let expenseService = BasicExpenseService(context: context)
        expenseService.addExpense(expense)
        
        delegate?.didAddExpense(expense)
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Functions
    private func addDoneButtonToKeyboards() {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        doneToolbar.items = [flexSpace, doneButton]

        descriptionTextField.inputAccessoryView = doneToolbar
        amountTextField.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonTapped() {
        view.endEditing(true)
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
    private func descriptionsButtonTapped() {
        presentAlert(from: self, title: "Info about the description", message: "This description will be used to describe the expense throughout the application for your convenience")
    }

    private func inputAmountButtonTapped() {
        presentAlert(from: self, title: "Info about the input amount", message: "This number will be used to set the amount that you are going to input for this expense")
    }

    private func invalidInput() {
        presentAlert(from: self, title: "Invalid Input", message: "Please fill out all fields")
    }
}

// MARK: - Picker
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
