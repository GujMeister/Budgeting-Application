//
//  BudgetsVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import UIKit

class BudgetsViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = BudgetsViewModel()
    internal var shouldAnimateInfoView = true
    
    private var infoView: NavigationRectangle = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(height: screenSize / 4, color: UIColor(hex: "1B1A55"), totalBudgetedMoney: 0.0, descriptionLabelText: "Budget upper limit")
        view.totalBudgetedNumberLabel.textColor = .white
        view.descriptionLabel.textColor = .white
        return view
    }()
    
    private lazy var customSegmentedControlView = CustomSegmentedControlView(
        color: UIColor(hex: "535C91"),
        controlItems: ["Budgets", "Expenses"],
        defaultIndex: 0
    ) { [weak self] selectedIndex in
        self?.handleSegmentChange(selectedIndex: selectedIndex)
    }

    private var budgetsStackViewBackground: UIView = {
        let view = BorderLabelView(labelName: "Favorites")
        return view
    }()

    private var favoriteBudgetsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private var allBudgetsLabel: UILabel = {
        let label = UILabel()
        label.text = "All Budgets"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(hex: "0F1035")
        return label
    }()
    
    private lazy var addBudgetButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(hex: "0F1035")
        button.addAction(UIAction(handler: { _ in
            self.addBudget()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var allBudgetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: "f4f3f9")
        tableView.register(CustomBudgetCell.self, forCellReuseIdentifier: CustomBudgetCell.reuseIdentifier)
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
        viewModel.loadBudgets()
        handleSegmentChange(selectedIndex: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customSegmentedControlView.setSelectedIndex(0)
        animateSegmentedControlView()
        viewModel.loadBudgets() // es ro ara budget table view updates ar aketebs
        viewModel.loadFavoritedBudgets() // es ro ara bidget view updates ar aketebs
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#f4f3f9")
        self.navigationController?.isNavigationBarHidden = true
        
        let views = [customSegmentedControlView, infoView, allBudgetsLabel, allBudgetsTableView, budgetsStackViewBackground, addBudgetButton, favoriteBudgetsStackView]
        
        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4),
            
            customSegmentedControlView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -15),
            customSegmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSegmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            budgetsStackViewBackground.topAnchor.constraint(equalTo: favoriteBudgetsStackView.topAnchor, constant: 5),
            budgetsStackViewBackground.leadingAnchor.constraint(equalTo: favoriteBudgetsStackView.leadingAnchor, constant: -10),
            budgetsStackViewBackground.trailingAnchor.constraint(equalTo: favoriteBudgetsStackView.trailingAnchor, constant: 10),
            budgetsStackViewBackground.bottomAnchor.constraint(equalTo: favoriteBudgetsStackView.bottomAnchor, constant: 25),
            
            favoriteBudgetsStackView.topAnchor.constraint(equalTo: customSegmentedControlView.bottomAnchor, constant: 10),
            favoriteBudgetsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            favoriteBudgetsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteBudgetsStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8),
            
            allBudgetsLabel.topAnchor.constraint(equalTo: favoriteBudgetsStackView.bottomAnchor, constant: 50),
            allBudgetsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addBudgetButton.topAnchor.constraint(equalTo: allBudgetsLabel.topAnchor),
            addBudgetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            allBudgetsTableView.topAnchor.constraint(equalTo: allBudgetsLabel.bottomAnchor, constant: 10),
            allBudgetsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allBudgetsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allBudgetsTableView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    // MARK: - View Model Bindings
    private func setupBindings() {
        viewModel.onBudgetsUpdated = { [weak self] in
            self?.allBudgetsTableView.reloadData()
            self?.updateFavoriteBudgets()
        }
        
        viewModel.onFavoritedBudgetsUpdated = { [weak self] in
            self?.updateFavoriteBudgets()
        }
        
//        viewModel.onExpensesUpdated = { [weak self] in
//            self?.updateFavoriteBudgets()
//            self?.viewModel.refreshFavoriteBudgets()
//            self?.viewModel.loadBudgets()
//            self?.viewModel.loadFavoritedBudgets()
//        }
        
        viewModel.onTotalBudgetedMoneyUpdated = { [weak self] in
            self?.updateInfoView()
        }
    }
    
    // MARK: - Button Action
    func addBudget() {
        let addBudgetVC = AddCategoriesViewController()
        addBudgetVC.delegate = self
        self.present(addBudgetVC, animated: true, completion: nil)
    }
    
    // MARK: - View helper functions
    func updateFavoriteBudgets() {
        favoriteBudgetsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for budget in viewModel.favoritedBudgets.suffix(5) {
            let singleBudgetView = BudgetView()
            singleBudgetView.budget = budget
            favoriteBudgetsStackView.addArrangedSubview(singleBudgetView)
        }
    }
    
    private func updateInfoView() {
        infoView.totalBudgetedNumberLabel.attributedText = NumberFormatterHelper.shared.format(amount: viewModel.totalBudgetedMoney, baseFont: UIFont(name: "Heebo-SemiBold", size: 36) ?? UIFont(), sizeDifference: 0.6)
    }
    
    private func handleSegmentChange(selectedIndex: Int) {
        if selectedIndex == 0 {
            return
        } else {
            shouldAnimateInfoView = false
            let expensesViewController = ExpensesViewController()
            if let navigationController = navigationController {
                navigationController.pushViewController(expensesViewController, animated: false)
            }
        }
    }
    
    private func animateSegmentedControlView() {
        if shouldAnimateInfoView {
            customSegmentedControlView.transform = CGAffineTransform(translationX: 0, y: -50)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.customSegmentedControlView.transform = .identity
            }, completion: { _ in
                self.shouldAnimateInfoView = false
            })
        } else {
            customSegmentedControlView.transform = .identity
        }
    }
}

// MARK: - Add Categories Delegate
extension BudgetsViewController: AddCategoriesDelegate {
    func addCategory(_ category: BasicExpenseCategory, totalAmount: Double) {
        if checkForDuplicateCategory(category) {
            let alert = UIAlertController(title: "Duplicate Category", message: "This category already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newBudget = BasicExpenseBudgetModel(context: DataManager.shared.context)
        newBudget.category = category.rawValue
        newBudget.totalAmount = NSNumber(value: totalAmount)
        newBudget.spentAmount = 0
        
        do {
            try DataManager.shared.context.save()
            viewModel.loadBudgets()
        } catch {
            print("Failed to save new budget: \(error)")
        }
    }
    
    func checkForDuplicateCategory(_ category: BasicExpenseCategory) -> Bool {
        return viewModel.allBudgets.contains(where: { $0.category == category })
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BudgetsViewController: UITableViewDataSource, UITableViewDelegate, BudgetDetailViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allBudgetsTableView {
            return viewModel.allBudgets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allBudgetsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomBudgetCell.reuseIdentifier, for: indexPath) as! CustomBudgetCell
            let budget = viewModel.allBudgets[indexPath.row]
            cell.configure(with: budget)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(hex: "f4f3f9")
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allBudgetsTableView {
            let detailVC = BudgetDetailViewController()
            detailVC.budget = viewModel.allBudgets[indexPath.row]
            detailVC.delegate = self
            
            if let presentationController = detailVC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            
            present(detailVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteBudget(at: indexPath.row)
        }
    }
    
    func didUpdateFavoriteStatus(for budget: BasicExpenseBudget) {
        if viewModel.favoritedBudgets.contains(where: { $0.category == budget.category }) {
            viewModel.removeBudgetFromFavorites(budget)
        } else {
            viewModel.addBudgetToFavorites(budget)
        }
    }
}

#Preview {
    BudgetsViewController()
}
