import UIKit

class ExpensesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = BudgetsViewModel()
    
    private lazy var customSegmentedControlView = CustomSegmentedControlView(
        color: .blue,
        controlItems: ["Budgets", "Expenses"],
        defaultIndex: 1 ) { [weak self] selectedIndex in
        self?.handleSegmentChange(selectedIndex: selectedIndex)
    }
    
    private var infoView: UIView = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(height: screenSize / 4, color: .blue, totalBudgetedMoney: "$200", descriptionLabelText: "Total Budgeted")
        view.totalBudgetedNumberLabel.textColor = .white
        view.descriptionLabel.textColor = .white
        return view
    }()
    
    private lazy var addExpenseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addAction(UIAction(handler: { _ in
            self.addExpense()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var timePeriodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TimePeriodBackwards.lastWeek.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.addAction(UIAction(handler: { _ in
            self.showMenu()
        }), for: .touchUpInside)
        return button
    }()
    
    private var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomExpenseCell.self, forCellReuseIdentifier: CustomExpenseCell.reuseIdentifier)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadBudgets()
        viewModel.loadExpenses()
        handleSegmentChange(selectedIndex: 1)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.loadBudgets()
//        viewModel.loadExpenses()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customSegmentedControlView.setSelectedIndex(1)
        viewModel.loadBudgets()
        viewModel.loadFavoritedBudgets()
        viewModel.loadExpenses()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let views = [customSegmentedControlView, infoView, addExpenseButton, timePeriodButton, chevronImageView, expensesTableView]
        
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
            
            addExpenseButton.topAnchor.constraint(equalTo: customSegmentedControlView.bottomAnchor, constant: 10),
            addExpenseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timePeriodButton.centerYAnchor.constraint(equalTo: addExpenseButton.centerYAnchor),
            timePeriodButton.leadingAnchor.constraint(equalTo: chevronImageView.trailingAnchor, constant: 5),
            
            chevronImageView.centerYAnchor.constraint(equalTo: addExpenseButton.centerYAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            expensesTableView.topAnchor.constraint(equalTo: timePeriodButton.bottomAnchor, constant: 20),
            expensesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            expensesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            expensesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - View Model Bindings
    private func setupBindings() {
        viewModel.onExpensesUpdated = { [weak self] in
            self?.expensesTableView.reloadData()
        }
    }
    
    private func handleSegmentChange(selectedIndex: Int) {
        if selectedIndex == 1 {
            return
        } else {
            navigationController?.popViewController(animated: false)
        }
    }

    // MARK: - Button Actions
    private func addExpense() {
        let addExpensesVC = AddExpenseViewController()
        addExpensesVC.delegate = self
        self.present(addExpensesVC, animated: true, completion: nil)
    }
    
    private func showMenu() {
        let actions = TimePeriodBackwards.allCases.map { period in
            UIAction(title: period.rawValue) { [weak self] _ in
                self?.timePeriodButton.setTitle(period.rawValue, for: .normal)
                self?.viewModel.selectedTimePeriod = period
                self?.viewModel.loadExpenses()
            }
        }
        let menu = UIMenu(title: "", options: .displayInline, children: actions)
        timePeriodButton.menu = menu
        timePeriodButton.showsMenuAsPrimaryAction = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.expensesByDate.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.sortedExpenseDates[section]
        return viewModel.expensesByDate[date]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.sortedExpenseDates[section]
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = viewModel.sortedExpenseDates[indexPath.section]
        let expense = viewModel.expensesByDate[date]?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomExpenseCell.reuseIdentifier, for: indexPath) as! CustomExpenseCell
        if let expense = expense {
            cell.configure(with: expense)
        }
        return cell
    }
}

// MARK: - AddExpenseDelegate
extension ExpensesViewController: AddExpenseDelegate {
    func updateBudgets(_ expense: BasicExpenseModel) {
        let context = DataManager.shared.context
        let service = BasicExpenseService(context: context)
        service.addExpense(expense)
    }

    func didAddExpense(_ expense: BasicExpenseModel) {
        viewModel.loadExpenses()
        viewModel.loadBudgets()
        viewModel.loadFavoritedBudgets() // Ensure favorite budgets are updated
    }
}
