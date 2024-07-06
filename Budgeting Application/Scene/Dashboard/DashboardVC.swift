import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = DashboardViewModel()
    
    private var infoView: UIView = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(height: screenSize / 4, color: .blue, totalBudgetedMoney: 121.50, descriptionLabelText: "Total Budgeted")
        return view
    }()
    
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Budgeting"
        return label
    }()
    
    private let addBudgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add budget", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside)
        return button
    }()
    
    private var budgetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let upcomingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.text = "Upcoming"
        return label
    }()
    
    private let subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Subscriptions"
        return label
    }()
    
    private let addSubscriptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add subscription", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(addSubscriptionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var subscriptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchBudgets()
        viewModel.fetchSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBudgets()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        let views = [budgetStackView, infoView, budgetLabel, addBudgetButton, upcomingLabel, subscriptionsLabel, addSubscriptionButton, subscriptionCollectionView]
        
        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            budgetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            budgetLabel.bottomAnchor.constraint(equalTo: budgetStackView.topAnchor, constant: -40),
            
            addBudgetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addBudgetButton.bottomAnchor.constraint(equalTo: budgetStackView.topAnchor, constant: -40),
            
            budgetStackView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 90),
            budgetStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            budgetStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            upcomingLabel.topAnchor.constraint(equalTo: budgetStackView.bottomAnchor, constant: 90),
            upcomingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subscriptionsLabel.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor, constant: 10),
            subscriptionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addSubscriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addSubscriptionButton.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor, constant: 10),
            
            subscriptionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subscriptionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            subscriptionCollectionView.topAnchor.constraint(equalTo: addSubscriptionButton.bottomAnchor, constant: 20),
            subscriptionCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 10)
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        viewModel.onBudgetsUpdated = { [weak self] in
            self?.updateBudgets()
        }
        
        viewModel.onSubscriptionsUpdated = { [weak self] in
            self?.updateSubscriptions()
        }
    }
    
    // MARK: - Actions
    @objc private func addExpenseTapped() {
        let addExpenseVC = AddCategoriesViewController()
        navigationController?.pushViewController(addExpenseVC, animated: true)
    }
    
    @objc private func addSubscriptionTapped() {
        let addSubscriptionVC = AddSubscriptionVC()
        addSubscriptionVC.delegate = self
        navigationController?.pushViewController(addSubscriptionVC, animated: true)
    }
    
    // MARK: - Helper Functions
    private func updateBudgets() {
        budgetStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for budget in viewModel.budgets {
            let singleBudgetView = BudgetView()
            singleBudgetView.budget = budget
            budgetStackView.addArrangedSubview(singleBudgetView)
        }
    }
    
    private func updateSubscriptions() {
        subscriptionCollectionView.reloadData()
    }
}

// MARK: - Collection View
extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(viewModel.subscriptions.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier, for: indexPath) as! SubscriptionCollectionViewCell
        cell.configure(with: viewModel.subscriptions[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let subscription = viewModel.subscriptions[indexPath.row]
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = (subscription.subscriptionDescription ?? "") + String(subscription.amount)
        label.sizeToFit()
        let width = min(label.frame.width + 70, label.frame.width + 100)
        return CGSize(width: width, height: UIScreen.main.bounds.height / 17)
    }
}

extension DashboardViewController: AddSubscriptionDelegate {
    func didAddSubscription(_ subscription: SubscriptionExpenseModel) {
        viewModel.subscriptions.append(subscription)
        viewModel.onSubscriptionsUpdated?()
    }
}

// MARK: - Preview
#Preview {
    DashboardViewController()
}
