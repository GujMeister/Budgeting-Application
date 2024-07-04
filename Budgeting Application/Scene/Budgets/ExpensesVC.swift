import UIKit

class ExpensesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = BudgetsViewModel()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var customSegmentedControlView = CustomSegmentedControlView(
        color: .blue,
        controlItems: ["Budgets", "Expenses"], defaultIndex: 1
    ) { [weak self] selectedIndex in
        self?.handleSegmentChange(selectedIndex: selectedIndex)
    }
    
    private var contentView = UIView()
    private var bottomView = UIView()
    
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
    
    private var expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExpenseCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBudgets()
        viewModel.loadExpenses()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        customSegmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        addExpenseButton.translatesAutoresizingMaskIntoConstraints = false
        timePeriodButton.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        expensesTableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(customSegmentedControlView)
        contentView.addSubview(infoView)
        contentView.addSubview(addExpenseButton)
        contentView.addSubview(timePeriodButton)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(expensesTableView)
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
            
            addExpenseButton.topAnchor.constraint(equalTo: customSegmentedControlView.bottomAnchor, constant: 10),
            addExpenseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            timePeriodButton.centerYAnchor.constraint(equalTo: addExpenseButton.centerYAnchor),
            timePeriodButton.leadingAnchor.constraint(equalTo: chevronImageView.trailingAnchor, constant: 5),
            
            chevronImageView.centerYAnchor.constraint(equalTo: addExpenseButton.centerYAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            expensesTableView.topAnchor.constraint(equalTo: timePeriodButton.bottomAnchor, constant: 20),
            expensesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expensesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            expensesTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.topAnchor.constraint(equalTo: expensesTableView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
    }
    
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
        let addExpensesVC = AddCategoriesViewController()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = "\(expense?.category.emoji ?? "") \(expense?.category.rawValue ?? ""): $\(expense?.amount ?? 0)"
        return cell
    }
}
