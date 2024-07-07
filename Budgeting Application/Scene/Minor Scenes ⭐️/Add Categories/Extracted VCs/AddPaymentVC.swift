//
//  AddPaymentVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 07.07.24.
//

import UIKit

protocol AddPaymentDelegate: AnyObject {
    func didAddPayment(_ subscription: PaymentExpenseModel)
}

class AddPaymentVC: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AddPaymentDelegate?
    
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
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let repeatCountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Repeat Count"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Subscription", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categories = PaymentsCategory.allCases
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [categoryPicker, descriptionTextField, amountTextField, datePicker, repeatCountTextField, addButton])
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
              let amountText = amountTextField.text, let amount = Double(amountText),
              let repeatCountText = repeatCountTextField.text, let repeatCount = Int(repeatCountText) else {
            // Handle invalid input
            return
        }
        
        let context = DataManager.shared.context
        let subscription = PaymentExpenseModel(context: context)
        subscription.category = category.rawValue
        subscription.paymentDescription = description
        subscription.amount = amount
        subscription.startDate = datePicker.date
        subscription.repeatCount = Int16(repeatCount)
        
        do {
            try context.save()
            delegate?.didAddPayment(subscription)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save subscription: \(error)")
        }
    }
}

extension AddPaymentVC: UIPickerViewDataSource, UIPickerViewDelegate {
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

