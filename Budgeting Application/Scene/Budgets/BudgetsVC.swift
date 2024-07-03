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
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var customSegmentedControlView = CustomSegmentedControlView(
        color: .blue,
        controlItems: ["Budgets", "Expenses"], 
        defaultIndex: 0
    ) { [weak self] selectedIndex in
        self?.handleSegmentChange(selectedIndex: selectedIndex)
    }
    
    private var contentView = UIView()
    private var bottomView = UIView()
    
    private var budgetsStackViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#e5f1ff")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private var infoView: UIView = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(height: screenSize / 4, color: .blue, totalBudgetedMoney: "$200", descriptionLabelText: "Total Budgeted")
        view.totalBudgetedNumberLabel.textColor = .white
        view.descriptionLabel.textColor = .white
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
        return label
    }()
    
    private lazy var allBudgetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomBudgetCell.self, forCellReuseIdentifier: CustomBudgetCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadBudgets()
        handleSegmentChange(selectedIndex: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customSegmentedControlView.setSelectedIndex(0) // Ensure the first segment is selected
        viewModel.loadBudgets()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        customSegmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        favoriteBudgetsStackView.translatesAutoresizingMaskIntoConstraints = false
        allBudgetsLabel.translatesAutoresizingMaskIntoConstraints = false
        allBudgetsTableView.translatesAutoresizingMaskIntoConstraints = false
        budgetsStackViewBackground.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(customSegmentedControlView)
        contentView.addSubview(infoView)
        contentView.addSubview(budgetsStackViewBackground)
        contentView.addSubview(favoriteBudgetsStackView)
        contentView.addSubview(allBudgetsLabel)
        contentView.addSubview(allBudgetsTableView)
        contentView.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4),
            
            customSegmentedControlView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -15),
            customSegmentedControlView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSegmentedControlView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            budgetsStackViewBackground.topAnchor.constraint(equalTo: favoriteBudgetsStackView.topAnchor, constant: 10),
            budgetsStackViewBackground.leadingAnchor.constraint(equalTo: favoriteBudgetsStackView.leadingAnchor),
            budgetsStackViewBackground.trailingAnchor.constraint(equalTo: favoriteBudgetsStackView.trailingAnchor),
            budgetsStackViewBackground.bottomAnchor.constraint(equalTo: favoriteBudgetsStackView.bottomAnchor, constant: 18),
            
            favoriteBudgetsStackView.topAnchor.constraint(equalTo: customSegmentedControlView.bottomAnchor, constant: 0),
            favoriteBudgetsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            favoriteBudgetsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteBudgetsStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8),
            
            allBudgetsLabel.topAnchor.constraint(equalTo: favoriteBudgetsStackView.bottomAnchor, constant: 35),
            allBudgetsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            allBudgetsTableView.topAnchor.constraint(equalTo: allBudgetsLabel.bottomAnchor, constant: 10),
            allBudgetsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            allBudgetsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            allBudgetsTableView.heightAnchor.constraint(equalToConstant: 200),
            
            bottomView.topAnchor.constraint(equalTo: allBudgetsTableView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Helper Functions
    private func setupBindings() {
        viewModel.onBudgetsUpdated = { [weak self] in
            self?.allBudgetsTableView.reloadData()
            self?.updateFavoriteBudgets()
        }
        
        viewModel.onFavoritedBudgetsUpdated = { [weak self] in
            self?.updateFavoriteBudgets()
        }
    }
    
    private func updateFavoriteBudgets() {
        favoriteBudgetsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for budget in viewModel.favoritedBudgets.suffix(5) {
            print("adding views")
            let singleBudgetView = BudgetView()
            singleBudgetView.budget = budget
            favoriteBudgetsStackView.addArrangedSubview(singleBudgetView)
        }
    }
    
    private func handleSegmentChange(selectedIndex: Int) {
        if selectedIndex == 0 {
            return
        } else {
            let expensesViewController = ExpensesViewController()
            navigationController?.pushViewController(expensesViewController, animated: false)
        }
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
    
    func didUpdateFavoriteStatus(for budget: BasicExpenseBudget) {
        viewModel.loadFavoritedBudgets()
    }
}

#Preview {
    BudgetsViewController()
}
