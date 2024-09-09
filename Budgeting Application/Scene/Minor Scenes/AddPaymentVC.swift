//
//  AddPaymentVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 07.07.24.
//

import UIKit

protocol AddPaymentDelegate: AnyObject {
    func didAddPayment(_ subscription: PaymentExpense)
}

final class AddPaymentVC: UIViewController {
    // MARK: - Properties
    weak var delegate: AddPaymentDelegate?
    private lazy var keyboardHandler = KeyboardHandler(viewController: self)
    
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
        label.text = "add_payment_category_label".translated()
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
        label.text = "add_payment_description_label".translated()
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "add_payment_description_placeholder".translated()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .infoViewColor
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
        label.text = "add_payment_amount_label".translated()
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "add_payment_amount_placeholder".translated()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var amountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .infoViewColor
        
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
    
    private let repeatCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "add_payment_repeat_label".translated()
        return label
    }()
    
    private let repeatCountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "add_payment_repeat_placeholder".translated()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .infoViewColor
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.monthsButtonTapped()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("add_payment_button_title".translated(), for: .normal)
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.addButtonTapped()
        }), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Regular", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .infoViewColor
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let categories = PaymentsCategory.allCases
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyboardHandler.addDoneButtonToKeyboard(for: [descriptionTextField, amountTextField, repeatCountTextField])
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        let views = [topView, categoryLabel, categoryPicker, descriptionLabel, descriptionTextField, descriptionButton, amountLabel, amountTextField, amountButton, datePicker, repeatCountTextField, addButton, repeatCountLabel, repeatButton]
        
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
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionButton.centerYAnchor.constraint(equalTo: descriptionTextField.centerYAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionButton.leadingAnchor, constant: -20),
            
            amountLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 10),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 3),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            amountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            amountButton.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: amountButton.leadingAnchor, constant: -20),
            
            repeatCountLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10),
            repeatCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            repeatCountTextField.topAnchor.constraint(equalTo: repeatCountLabel.bottomAnchor, constant: 3),
            repeatCountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            repeatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatButton.centerYAnchor.constraint(equalTo: repeatCountTextField.centerYAnchor),
            repeatButton.leadingAnchor.constraint(equalTo: repeatCountTextField.trailingAnchor, constant: 20),
            
            datePicker.topAnchor.constraint(equalTo: repeatButton.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 15),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Helper functions
    private func addButtonTapped() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let category = categories[selectedCategoryIndex]
        
        guard let description = descriptionTextField.text, !description.isEmpty,
              let amountText = amountTextField.text?.replacingOccurrences(of: ",", with: "."),
              let amount = Double(amountText),
              let repeatCountText = repeatCountTextField.text, let repeatCount = Int(repeatCountText) else {
            invalidInput()
            return
        }
        
        // Validate description length
        if description.count < 2 || description.count > 40 {
            presentAlert(from: self, title: "invalid_description_title".translated(), message: "invalid_description_message".translated())
            return
        }
        
        // Validate amount
        let amountComponents = amountText.split(separator: ".")
        if amount <= 0 || amount > 50000 || (amountComponents.count == 2 && amountComponents[1].count > 2) {
            presentAlert(from: self, title: "invalid_amount_title".translated(), message: "invalid_amount_message".translated())
            return
        }
        
        // Validate repeat count
        if repeatCount <= 0 || repeatCount > 600 || repeatCountText.contains(".") {
            presentAlert(from: self, title: "invalid_repeat_count_title".translated(), message: "invalid_repeat_count_message".translated())
            return
        }
        
        let payment = PaymentExpense(
            category: category,
            paymentDescription: description,
            amount: amount,
            startDate: datePicker.date,
            repeatCount: repeatCount
        )
        
        delegate?.didAddPayment(payment)

        dismiss(animated: true)
    }

    // MARK: - Information Alerts
    private func descriptionsButtonTapped() {
        presentAlert(from: self, title: "info_description_title".translated(), message: "info_description_message".translated())
    }

    private func inputAmountButtonTapped() {
        presentAlert(from: self, title: "info_amount_title".translated(), message: "info_amount_message".translated())
    }

    private func monthsButtonTapped() {
        presentAlert(from: self, title: "info_repeat_count_title".translated(), message: "info_repeat_count_message".translated())
    }

    private func invalidInput() {
        presentAlert(from: self, title: "invalid_input_title".translated(), message: "invalid_input_message".translated())
    }
}

// MARK: - Picker
extension AddPaymentVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue.translated()
    }
}
