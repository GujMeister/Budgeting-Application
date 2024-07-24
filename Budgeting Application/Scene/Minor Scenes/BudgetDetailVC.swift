//
//  BudgetDetailVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import UIKit

final class DashboardBudgetDetailViewController: UIViewController {
    // MARK: - Properties
    private let budget: BasicExpenseBudget
    weak var delegate: AddExpenseDelegate?
    private let scrollView = UIScrollView()
    private lazy var keyboardHandler = KeyboardHandler(viewController: self)
    
    private let remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let spentAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let maxAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var progressView: CircularProgressView = {
        let view = CircularProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addExpenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Bold", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Expense"
        return label
    }()
    
    private let addExpenseToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "ChesnaGrotesk-Medium", size: 16)
        label.text = "Input Expense Description"
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g Chocolate"
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
        textField.placeholder = "e.g 50"
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
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var addExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Expense", for: .normal)
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapAddExpense()
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
    
    let progressViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .infoViewColor
        view.layer.shadowColor = UIColor.infoViewColor.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 25
        return view
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
        setupUI()
        configureView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .backgroundColor
        
        let views = [progressViewBackground, progressView, spentAmountLabel, maxAmountLabel, remainingAmountLabel, addExpenseLabel, addExpenseToLabel, descriptionLabel, descriptionTextField, descriptionButton, amountLabel, amountTextField, amountButton, datePicker, addExpenseButton]
        
        views.forEach { eachView in
            view.addSubview(eachView)
            eachView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            progressView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            
            spentAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width / 7),
            spentAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            maxAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.main.bounds.width / 7)),
            maxAmountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            
            remainingAmountLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            remainingAmountLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            
            addExpenseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addExpenseLabel.topAnchor.constraint(equalTo: maxAmountLabel.bottomAnchor, constant: 30),
            
            addExpenseToLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addExpenseToLabel.topAnchor.constraint(equalTo: addExpenseLabel.bottomAnchor, constant: 3),
            
            descriptionLabel.topAnchor.constraint(equalTo: addExpenseToLabel.bottomAnchor, constant: 15),
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
            addExpenseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressViewBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            progressViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            progressViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            progressViewBackground.bottomAnchor.constraint(equalTo: spentAmountLabel.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Helper Functions
    private func configureView() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        let titleView = UIView()
        titleView.backgroundColor = .backgroundColor
        titleView.layer.cornerRadius = 8
        titleView.layer.masksToBounds = true
        titleView.alpha = 0

        let titleLabel = UILabel()
        titleLabel.text = budget.category.emoji
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.alpha = 0
        
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        self.navigationItem.titleView = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: 35),
            titleView.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        UIView.animate(withDuration: 0.4) {
            titleView.alpha = 1
            titleLabel.alpha = 1
        }
        
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
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Alerts
    private func inputAmountButtonTapped() {
        presentAlert(from: self, title: "Info about the input amount", message: "This number will be used to set the amount that you are going to budget every month for this payment")
    }
    
    private func invalidInput() {
        presentAlert(from: self, title: "Invalid Input", message: "Please fill out all fields")
    }
    
    private func descriptionsButtonTapped() {
        presentAlert(from: self, title: "Info about the description", message: "This description will be used to describe the expense throughout the application for your convenience")
    }
}
