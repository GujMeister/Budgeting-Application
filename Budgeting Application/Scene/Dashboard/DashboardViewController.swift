//
//  DashboardVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.

import UIKit
import DGCharts

final class DashboardViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DashboardViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoView: NavigationRectangle = {
        let screenSize = UIScreen.main.bounds.height
        let view = NavigationRectangle(
            height: screenSize / 4.5,
            color: UIColor(hex: "468585"),
            totalBudgetedMoney: NSMutableAttributedString(string: "1234"),
            descriptionLabelText: "Total Budgeted"
        )
        return view
    }()
    
    private lazy var budgetingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Budgets", for: .normal)
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        
        let config = UIImage.SymbolConfiguration(pointSize: 9)
        let chevron = UIImage(systemName: "chevron.right", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = .tertiaryTextColor
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.pushBudgetsViewController()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var budgetsStackViewBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.backgroundColor = .cellBackgroundColor
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
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        
        let config = UIImage.SymbolConfiguration(pointSize: 9)
        let chevron = UIImage(systemName: "chevron.right", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = .tertiaryTextColor
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.pushRecurringViewController()
        }), for: .touchUpInside)
        
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
        collectionView.backgroundColor = .clear
        collectionView.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
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
    
    private lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.chartDescription.enabled = false
        pieChart.legend.enabled = true
        pieChart.holeColor = .backgroundColor
        return pieChart
    }()
    
    private lazy var pieChartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chart ", for: .normal)
        button.titleLabel?.font = UIFont(name: "ChesnaGrotesk-Bold", size: 14)
        
        let config = UIImage.SymbolConfiguration(pointSize: 9)
        let chevron = UIImage(systemName: "info.circle.fill", withConfiguration: config)
        button.setImage(chevron, for: .normal)
        button.tintColor = .tertiaryTextColor
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapChartButton()
        }), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Placeholder Views (Initially hidden)
    private lazy var noSubscriptionsLabel: UILabel = {
        let label = UILabel()
        label.text = "No subscriptions saved"
        label.textColor = .primaryTextColor
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var noPaymentsLabel: UILabel = {
        let label = UILabel()
        label.text = "No bank payments to display"
        label.textColor = .primaryTextColor
        label.font = UIFont(name: "Montserrat-Medium", size: 13)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var noFavoriteBudgetsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.text = "No Budgets Favorited"
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var subscriptionBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .cellBackgroundColor
        view.isHidden = true
        return view
    }()
    
    private lazy var paymentsBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .cellBackgroundColor
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        viewModel.loadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .infoViewColor
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let views = [subscriptionBackgroundView, noSubscriptionsLabel, paymentsBackgroundView, noPaymentsLabel, budgetsStackViewBackground, budgetingButton, budgetStackView, infoView, upcomingButton, subscriptionCollectionView, paymentCollectionView, noFavoriteBudgetsLabel, pieChartButton, pieChartView]
        
        views.forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if UIScreen.main.bounds.height <= 736 {
            paymentCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3).isActive = true
        } else {
            paymentCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.6).isActive = true
        }
        
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
            
            budgetingButton.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 20),
            budgetingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            budgetStackView.topAnchor.constraint(equalTo: budgetingButton.bottomAnchor, constant: 5),
            budgetStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            budgetStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            budgetStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8),
            
            budgetsStackViewBackground.topAnchor.constraint(equalTo: budgetStackView.topAnchor, constant: 6),
            budgetsStackViewBackground.leadingAnchor.constraint(equalTo: budgetStackView.leadingAnchor, constant: -10),
            budgetsStackViewBackground.trailingAnchor.constraint(equalTo: budgetStackView.trailingAnchor, constant: 10),
            budgetsStackViewBackground.bottomAnchor.constraint(equalTo: budgetStackView.bottomAnchor, constant: 20),
            
            noFavoriteBudgetsLabel.centerXAnchor.constraint(equalTo: budgetsStackViewBackground.centerXAnchor),
            noFavoriteBudgetsLabel.centerYAnchor.constraint(equalTo: budgetsStackViewBackground.centerYAnchor),
            
            upcomingButton.topAnchor.constraint(equalTo: budgetStackView.bottomAnchor, constant: 30),
            upcomingButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            subscriptionBackgroundView.topAnchor.constraint(equalTo: subscriptionCollectionView.topAnchor, constant: 0),
            subscriptionBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subscriptionBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            subscriptionBackgroundView.bottomAnchor.constraint(equalTo: subscriptionCollectionView.bottomAnchor, constant: -10),
            subscriptionBackgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12),
            
            noSubscriptionsLabel.centerXAnchor.constraint(equalTo: subscriptionBackgroundView.centerXAnchor),
            noSubscriptionsLabel.centerYAnchor.constraint(equalTo: subscriptionBackgroundView.centerYAnchor),
            
            subscriptionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subscriptionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subscriptionCollectionView.topAnchor.constraint(equalTo: upcomingButton.bottomAnchor, constant: 5),
            subscriptionCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12),

            paymentsBackgroundView.topAnchor.constraint(equalTo: paymentCollectionView.topAnchor, constant: 10),
            paymentsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            paymentsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            paymentsBackgroundView.bottomAnchor.constraint(equalTo: paymentCollectionView.bottomAnchor, constant: 0),
            
            noPaymentsLabel.centerXAnchor.constraint(equalTo: paymentCollectionView.centerXAnchor),
            noPaymentsLabel.centerYAnchor.constraint(equalTo: paymentCollectionView.centerYAnchor),
            
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            paymentCollectionView.topAnchor.constraint(equalTo: subscriptionCollectionView.bottomAnchor, constant: -7),
            
            paymentCollectionView.bottomAnchor.constraint(equalTo: pieChartView.topAnchor, constant: -20),
            
            pieChartButton.topAnchor.constraint(equalTo: paymentCollectionView.bottomAnchor, constant: 10),
            pieChartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            pieChartView.topAnchor.constraint(equalTo: pieChartButton.bottomAnchor, constant: -10),
            pieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            pieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            pieChartView.heightAnchor.constraint(equalToConstant: 390),
            pieChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -130),
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        viewModel.onFavoritedBudgetsUpdated = { [weak self] in
            self?.budgetStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
            for budget in self?.viewModel.favoritedBudgets ?? [] {
                let singleBudgetView = BudgetView()
                singleBudgetView.budget = budget
                singleBudgetView.shouldExecuteTapAction = true
                self?.budgetStackView.addArrangedSubview(singleBudgetView)
            }
        }
        
        viewModel.onSubscriptionsUpdated = { [weak self] in
            self?.subscriptionCollectionView.reloadData()
        }
        
        viewModel.onPaymentsUpdated = { [weak self] in
            self?.paymentCollectionView.reloadData()
        }
        
        viewModel.onTotalBudgetedThisMonthUpdated = { [weak self] in
            self?.infoView.totalBudgetedNumberLabel.attributedText = NumberFormatterHelper.shared.format(
                amount: self?.viewModel.totalBudgetedThisMonth ?? 0,
                baseFont: UIFont(name: "Heebo-SemiBold", size: 36) ?? UIFont(),
                sizeDifference: 0.6
            )
            self?.updatePieChart()
        }
        
        viewModel.onBudgetsPlaceholderUpdated = { [weak self] isEmpty in
            self?.noFavoriteBudgetsLabel.isHidden = !isEmpty
        }
        
        viewModel.onSubscriptionsPlaceholderUpdated = { [weak self] isEmpty in
            self?.noSubscriptionsLabel.isHidden = !isEmpty
            self?.subscriptionBackgroundView.isHidden = !isEmpty
        }
        
        viewModel.onPaymentsPlaceholderUpdated = { [weak self] isEmpty in
            self?.noPaymentsLabel.isHidden = !isEmpty
            self?.paymentsBackgroundView.isHidden = !isEmpty
        }
        
        viewModel.onPieChartUpdated = { [weak self] in
            self?.updatePieChart()
        }
    }
    
    // MARK: Binding Functions
    private func updatePieChart() {
        let dataSet = PieChartDataSet(entries: viewModel.pieChartData, label: "")
        dataSet.entryLabelFont = UIFont(name: "ChesnaGrotesk-Bold", size: 12)
        dataSet.valueFont = UIFont(name: "Heebo-SemiBold", size: 10)!
        dataSet.entryLabelColor = .infoViewColor
        dataSet.valueTextColor = .infoViewColor
        dataSet.colors = [
            UIColor(hex: "#ffb3ba"),
            UIColor(hex: "#baffc9"),
            UIColor(hex: "#ffdfba")
        ]

        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DollarValueFormatter())

        pieChartView.data = data
    }
    
    // MARK: - Actions
    private func pushBudgetsViewController() {
        tabBarController?.selectedIndex = 2
    }
    
    private func pushRecurringViewController() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc private func budgetTapped(_ notification: Notification) {
        if let budget = notification.object as? BasicExpenseBudget {
            let budgetDetailVC = DashboardBudgetDetailViewController(budget: budget, delegate: viewModel)
            self.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(budgetDetailVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
    
    // MARK: - Alerts and Notifications
    private func didTapChartButton() {
        presentAlert(from: self, title: "Chart", message: "Pie chart below will show you your monthly expenditure by three categories such as Subscriptions, Bank Payments and Budgets")
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(budgetTapped(_:)), name: NSNotification.Name("BudgetTapped"), object: nil)
    }
}

// MARK: - Collection View Data Source
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subscriptionCollectionView {
            return viewModel.filteredSubscriptions.count
        } else if collectionView == paymentCollectionView {
            return viewModel.filteredPayments.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subscriptionCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCollectionViewCell.reuseIdentifier, for: indexPath) as! SubscriptionCollectionViewCell
            let occurrence = viewModel.filteredSubscriptions[indexPath.row]
            cell.configure(with: occurrence)
            return cell
            
        } else if collectionView == paymentCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankPaymentCollectionViewCell.reuseIdentifier, for: indexPath) as! BankPaymentCollectionViewCell
            let occurrence = viewModel.filteredPayments[indexPath.row]
            cell.configure(with: occurrence)
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
            let totalSpacing = (spacing * 2)
            let cellWidth = (screenWidth - totalSpacing) / 2
            let cellHeight = screenWidth / 3.7
            return CGSize(width: cellWidth, height: cellHeight)
        } else if collectionView == subscriptionCollectionView {
            guard viewModel.filteredSubscriptions.indices.contains(indexPath.row) else {
                return CGSize(width: 100, height: 50)
            }
            
            let subscription = viewModel.filteredSubscriptions[indexPath.row]
            let label = UILabel()
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.text = subscription.subscriptionDescription + PlainNumberFormatterHelper.shared.format(amount: subscription.amount)
            label.sizeToFit()
            let width = max(label.frame.width + 45, label.frame.width + 55)
            return CGSize(width: width, height: UIScreen.main.bounds.height / 22)
        } else {
            return CGSize(width: 100, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == paymentCollectionView {
            let insets: CGFloat = 7
            let verticalInsets: CGFloat = 5
            return UIEdgeInsets(top: verticalInsets, left: insets, bottom: verticalInsets, right: insets)
        } else if collectionView == subscriptionCollectionView {
            return .zero
        } else {
            return .zero
        }
    }
}
