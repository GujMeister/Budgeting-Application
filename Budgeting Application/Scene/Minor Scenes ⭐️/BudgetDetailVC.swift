//
//  BudgetDetailVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import UIKit

class DashboardBudgetDetailViewController: UIViewController {
    // MARK: - Properties
    private let budget: BasicExpenseBudget
    weak var delegate: AddExpenseDelegate?
    private lazy var keyboardHandler = KeyboardHandler(viewController: self)

    private let remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let maxAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var progressView: CircularProgressView = {
        let view = CircularProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Add expense
    private let addExpenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Expense"
        return label
    }()
    
    //TODO: Needs function so it says "to: Entertainment" for example
    private let addExpenseToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NEED FUNCTIONS FOR THIS!"
        return label
    }()
    
    //Description
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "Input Expense Description" // Changed text
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "" // Changed placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .customBlue
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        
//        button.addAction(UIAction(handler: { [weak self] _ in
//            self?.descriptionsButtonTapped()
//        }), for: .touchUpInside)
        
        return button
    }()
    
    //amount label
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
//        
//        button.addAction(UIAction(handler: { [weak self] _ in
//            self?.inputAmountButtonTapped()
//        }), for: .touchUpInside)

        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var addExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Expense", for: .normal) // Changed text
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapAddExpense()
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
    
    // MARK: - Initialization
    init(budget: BasicExpenseBudget, delegate: AddExpenseDelegate?) {
        self.budget = budget
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.addDoneButtonToKeyboard(for: [descriptionTextField, amountTextField])
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        configureView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        let views = [progressView, spentAmountLabel, maxAmountLabel, remainingAmountLabel, addExpenseLabel, addExpenseToLabel, descriptionLabel, descriptionTextField, descriptionButton, amountLabel, amountTextField, amountButton, datePicker, addExpenseButton]
        
        views.forEach { eachView in
            view.addSubview(eachView)
            eachView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            progressView.widthAnchor.constraint(equalToConstant: 180),
            progressView.heightAnchor.constraint(equalToConstant: 180),
            
            spentAmountLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            spentAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            maxAmountLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            maxAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            remainingAmountLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            remainingAmountLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            
            addExpenseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addExpenseLabel.topAnchor.constraint(equalTo: maxAmountLabel.bottomAnchor, constant: 40),
            
            addExpenseToLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addExpenseToLabel.topAnchor.constraint(equalTo: addExpenseLabel.bottomAnchor, constant: 5),
            
            descriptionLabel.topAnchor.constraint(equalTo: addExpenseToLabel.bottomAnchor, constant: 20),
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

            addExpenseButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            addExpenseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    private func configureView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = budget.category.rawValue
        addExpenseToLabel.text = "to: \(budget.category.rawValue)"
        
        if budget.remainingAmount < 0 {
            remainingAmountLabel.text = "Overdue:\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        } else {
            remainingAmountLabel.text = "Remaining:\n\(PlainNumberFormatterHelper.shared.format(amount: abs(budget.remainingAmount)))"
        }
        
        spentAmountLabel.text = "Spent: \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.spentAmount)))"
        maxAmountLabel.text = "Max: \(PlainNumberFormatterHelper.shared.format(amount: abs(budget.totalAmount)))"
        progressView.setProgress(spent: budget.spentAmount, total: budget.totalAmount, animated: true)
    }
    private func didTapAddExpense() {
        let category = budget.category
        
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


        delegate?.didAddExpense(expense)
        
        // Temporarily push and pop the BudgetsViewController to trigger updates
        if let navigationController = self.navigationController {
            let budgetsViewModel = BudgetsViewModel()
            let budgetsViewController = BudgetsViewController(viewModel: budgetsViewModel)
            
            navigationController.pushViewController(budgetsViewController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                navigationController.popViewController(animated: false)
                // Pop current view controller after updating
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            // Pop current view controller directly if no navigation controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func invalidInput() {
        presentAlert(from: self, title: "Invalid Input", message: "Please fill out all fields")
    }
}
