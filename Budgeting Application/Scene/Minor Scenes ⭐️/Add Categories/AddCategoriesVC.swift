//
//  AddCategoriesViewController.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import UIKit
import CoreData

class AddCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let totalBudgetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Willing to spend"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let alreadySpentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Already spent"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Budget", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var selectedCategory: BasicExpenseCategory?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        // Fetch initial data
        DataManager.shared.fetchBasicExpenseBudgets()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add Categories"
        
        view.addSubview(tableView)
        view.addSubview(categoryPicker)
        view.addSubview(totalBudgetTextField)
        view.addSubview(alreadySpentTextField)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalBudgetTextField.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            totalBudgetTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalBudgetTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            alreadySpentTextField.topAnchor.constraint(equalTo: totalBudgetTextField.bottomAnchor, constant: 20),
            alreadySpentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alreadySpentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            addButton.topAnchor.constraint(equalTo: alreadySpentTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        guard let selectedCategory = selectedCategory,
              let dollarsToBudget = totalBudgetTextField.text,
              let amountToBudget = Double(dollarsToBudget),
              let alreadySpent = alreadySpentTextField.text,
              let alreadySpentMoney = Double(alreadySpent) else {
            // Show an error message to the user
            let alert = UIAlertController(title: "Invalid Input", message: "Please select a category and enter a valid amount.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        DataManager.shared.addBasicExpenseBudget(category: selectedCategory.rawValue, spentAmount: NSNumber(value: amountToBudget), totalAmount: NSNumber(value: alreadySpentMoney))

        tableView.reloadData()
        
        // Clear the text fields
        totalBudgetTextField.text = ""
        alreadySpentTextField.text = ""
        tableView.reloadData()
    }
    
    // MARK: - UIPickerView Data Source & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BasicExpenseCategory.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BasicExpenseCategory.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = BasicExpenseCategory.allCases[row]
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.basicExpenseBudgetModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let budget = DataManager.shared.basicExpenseBudgetModelList[indexPath.row]
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
//        cell.textLabel?.text = budget.spentAmount
        cell.detailTextLabel?.text = budget.category
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budget = DataManager.shared.basicExpenseBudgetModelList[indexPath.row]
            DataManager.shared.deleteBasicExpenseBudget(expense: budget)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

