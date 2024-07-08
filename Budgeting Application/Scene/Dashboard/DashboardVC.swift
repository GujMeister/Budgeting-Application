import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = DashboardViewModel()
    
    private var viewBackgroundColors = UIColor.customBackground
    private var backgroundColor = UIColor.customBackground
    private var textColor = UIColor.black
    private var cellTextColors = UIColor.black
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoView: NavigationRectangle = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(height: screenSize / 4, color: .customBlue, totalBudgetedMoney: NSMutableAttributedString(string: "1234"), descriptionLabelText: "Total Budgeted")
        return view
    }()
    
    private lazy var budgetingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Budgets", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        // Add chevron right image
        let config = UIImage.SymbolConfiguration(pointSize: 10) // Desired size
        let chevron = UIImage(systemName: "chevron.right", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = textColor
        button.semanticContentAttribute = .forceRightToLeft
        
//        button.addAction(UIAction(handler: { _ in
//            self.addBudget()
//        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var budgetsStackViewBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = viewBackgroundColors
        view.layer.masksToBounds = false  // Ensure this is false to allow shadows
        view.layer.shadowColor = UIColor.customBlue.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }()

    private var budgetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    private lazy var upcomingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upcoming", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        // Add chevron right image
        let config = UIImage.SymbolConfiguration(pointSize: 10) // Desired size
        let chevron = UIImage(systemName: "chevron.right", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = textColor
        button.semanticContentAttribute = .forceRightToLeft

//        button.addAction(UIAction(handler: { _ in
//            self.addBudget()
//        }), for: .touchUpInside)
        
        return button
    }()
    
//    private lazy var subscriptionBackgroundView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 25
//        view.backgroundColor = viewBackgroundColors
//        view.layer.masksToBounds = false  // Ensure this is false to allow shadows
//        view.layer.shadowColor = UIColor.customBlue.cgColor
//        view.layer.shadowOffset = CGSize(width: 3, height: 3)
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowRadius = 5
//        return view
//    }()

    private lazy var subscriptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
//    private lazy var paymentsBackgroundView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 25
//        view.backgroundColor = viewBackgroundColors
//        view.layer.masksToBounds = false  // Ensure this is false to allow shadows
//        view.layer.shadowColor = UIColor.customBlue.cgColor
//        view.layer.shadowOffset = CGSize(width: 3, height: 3)
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 5
//        return view
//    }()

    private lazy var paymentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(BankPaymentCollectionViewCell.self, forCellWithReuseIdentifier: BankPaymentCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = backgroundColor
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let views = [/*subscriptionBackgroundView*/ /*paymentsBackgroundView*/ budgetsStackViewBackground, budgetingButton, budgetStackView, infoView, upcomingButton, /*subscriptionsLabel*/ subscriptionCollectionView, /*paymentsLabel*/ paymentCollectionView]
        
        views.forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // InfoView constraints
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            budgetingButton.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 25),
            budgetingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            budgetStackView.topAnchor.constraint(equalTo: budgetingButton.bottomAnchor, constant: 10),
            budgetStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            budgetStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            budgetStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8),

            budgetsStackViewBackground.topAnchor.constraint(equalTo: budgetStackView.topAnchor, constant: 0),
            budgetsStackViewBackground.leadingAnchor.constraint(equalTo: budgetStackView.leadingAnchor, constant: -10),
            budgetsStackViewBackground.trailingAnchor.constraint(equalTo: budgetStackView.trailingAnchor, constant: 10),
            budgetsStackViewBackground.bottomAnchor.constraint(equalTo: budgetStackView.bottomAnchor, constant: 25),
            
            upcomingButton.topAnchor.constraint(equalTo: budgetStackView.bottomAnchor, constant: 40),
            upcomingButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            //Subscriptions View
//            subscriptionBackgroundView.topAnchor.constraint(equalTo: subscriptionCollectionView.topAnchor, constant: -10),
//            subscriptionBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            subscriptionBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            subscriptionBackgroundView.bottomAnchor.constraint(equalTo: subscriptionCollectionView.bottomAnchor, constant: 0),

            subscriptionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subscriptionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subscriptionCollectionView.topAnchor.constraint(equalTo: upcomingButton.bottomAnchor, constant: 0),
            subscriptionCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 10),
            
            //Payments View
//            paymentsBackgroundView.topAnchor.constraint(equalTo: paymentCollectionView.topAnchor, constant: -20),
//            paymentsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            paymentsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            paymentsBackgroundView.bottomAnchor.constraint(equalTo: paymentCollectionView.bottomAnchor, constant: 0),
            
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            paymentCollectionView.topAnchor.constraint(equalTo: subscriptionCollectionView.bottomAnchor, constant: 5),
            paymentCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.5),
            paymentCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -170)
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        viewModel.onFavoritedBudgetsUpdated = { [weak self] in
            self?.updateBudgets()
        }
        
        viewModel.onSubscriptionsUpdated = { [weak self] in
            self?.subscriptionCollectionView.reloadData()
        }

        viewModel.onPaymentsUpdated = { [weak self] in
            self?.paymentCollectionView.reloadData()
        }
        
        viewModel.onTotalBudgetedThisMonthUpdated = { [weak self] in
            self?.updateTotalBudgetedLabel()
        }
    }
    
    // MARK: - Actions
//    @objc private func addExpenseTapped() {
//        let addExpenseVC = AddCategoriesViewController()
//        navigationController?.pushViewController(addExpenseVC, animated: true)
//    }
//    
//    @objc private func addSubscriptionTapped() {
//        let addSubscriptionVC = AddSubscriptionVC()
//        addSubscriptionVC.delegate = self
//        navigationController?.pushViewController(addSubscriptionVC, animated: true)
//    }
    
    // MARK: - Helper Functions
    private func updateBudgets() {
        budgetStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for budget in viewModel.favoritedBudgets {
            let singleBudgetView = BudgetView()
            singleBudgetView.budget = budget
            budgetStackView.addArrangedSubview(singleBudgetView)
        }
    }
    
    private func updateTotalBudgetedLabel() {
        infoView.totalBudgetedNumberLabel.attributedText = NumberFormatterHelper.shared.format(
            amount: viewModel.totalBudgetedThisMonth,
            baseFont: UIFont(name: "Heebo-SemiBold", size: 36) ?? UIFont(),
            sizeDifference: 0.6
        )
    }
}

// MARK: - Collection View Data Source
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subscriptionCollectionView {
            return viewModel.subscriptions.count
        } else if collectionView == paymentCollectionView {
            return viewModel.payments.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subscriptionCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier, for: indexPath) as! SubscriptionCollectionViewCell
            cell.configure(with: viewModel.subscriptions[indexPath.row], textColor: cellTextColors)
//            cell.backgroundColor = .red
            return cell
            
        } else if collectionView == paymentCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankPaymentCollectionViewCell.reuseIdentifier, for: indexPath) as! BankPaymentCollectionViewCell
            cell.configure(with: viewModel.payments[indexPath.row], textColor: cellTextColors)
//            cell.backgroundColor = .red
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - Collection View Delegate Flow Layout
extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == paymentCollectionView {
            let screenWidth = UIScreen.main.bounds.width
            let spacing: CGFloat = 25
            let totalSpacing = (spacing * 2) // 2 cells + 3 spaces
            let cellWidth = (screenWidth - totalSpacing) / 2 // Two cells per row
            let cellHeight = screenWidth / 3.2
            return CGSize(width: cellWidth, height: cellHeight)
        } else if collectionView == subscriptionCollectionView {
            // Subscription Collection View Layout
            // FIX: Check for index bounds before accessing the array
            guard viewModel.subscriptions.indices.contains(indexPath.row) else {
                // Handle out-of-bounds gracefully (return a default size)
                return CGSize(width: 100, height: 50)
            }

            let subscription = viewModel.subscriptions[indexPath.row]
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.text = (subscription.subscriptionDescription ?? "") + String(subscription.amount)
            label.sizeToFit()
            let width = min(label.frame.width + 70, label.frame.width + 100)
            return CGSize(width: width, height: UIScreen.main.bounds.height / 20)
        } else {
            // Default size for other collection views (if any)
            return CGSize(width: 100, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == paymentCollectionView {
            let insets: CGFloat = 7 // Set your desired inset value
            let verticalInsets: CGFloat = 5
            return UIEdgeInsets(top: verticalInsets, left: insets, bottom: verticalInsets, right: insets)
        } else if collectionView == subscriptionCollectionView {
            return .zero
        } else {
            return .zero
        }
    }
}

//extension DashboardViewController: AddSubscriptionDelegate {
//    func didAddSubscription(_ subscription: SubscriptionExpenseModel) {
//        viewModel.subscriptions.append(subscription)
//        viewModel.onSubscriptionsUpdated?()
//    }
//}

// MARK: - Preview
#Preview {
    DashboardViewController()
}
