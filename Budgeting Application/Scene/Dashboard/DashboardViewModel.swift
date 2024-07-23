//
//  DashboardVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData
import DGCharts

final class DashboardViewModel {
    // MARK: - Properties
    private var budgets: [BasicExpenseBudget] = []
    private var allExpenses: [BasicExpense] = []
    private var subscriptions: [SubscriptionExpenseModel] = []
    private var payments: [PaymentExpenseModel] = []
    
    //Pie chart
    private var totalBudgets: Double = 0.0
    private var totalPayments: Double = 0.0
    private var totalSubscriptions: Double = 0.0
    
    //Data To Show
    internal var filteredSubscriptions: [SubscriptionOccurrence] = [] {
        didSet {
            onSubscriptionsUpdated?()
        }
    }
    
    internal var filteredPayments: [PaymentOccurrence] = [] {
        didSet {
            onPaymentsUpdated?()
        }
    }
    
    internal var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    internal var totalBudgetedThisMonth: Double = 0.0 {
        didSet {
            onTotalBudgetedThisMonthUpdated?()
        }
    }
    
    internal var pieChartData: [PieChartDataEntry] = [] {
        didSet {
            onPieChartUpdated?()
        }
    }

    var onTotalBudgetedThisMonthUpdated: (() -> Void)?
    var onFavoritedBudgetsUpdated: (() -> Void)?
    var onSubscriptionsUpdated: (() -> Void)?
    var onPaymentsUpdated: (() -> Void)?
    var onBudgetsPlaceholderUpdated: ((Bool) -> Void)?
    var onSubscriptionsPlaceholderUpdated: ((Bool) -> Void)?
    var onPaymentsPlaceholderUpdated: ((Bool) -> Void)?
    var onBudgetsUpdated: (() -> Void)?
    var onPieChartUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    // MARK: - Initialization
    init() {
        loadData()
    }
    
    deinit {
        print("🗑️⬅️ Deiniting Dashboard VIEWMODEL")
    }
    
    // MARK: - Helper Functions
    func loadData() {
        fetchSubscriptions()
        fetchPayments()
        loadFavoritedBudgets()
        calculateTotalBudgetedThisMonth()
        loadFilteredOccurrences()
    }
    
    private func notifyPlaceholders() {
        onBudgetsPlaceholderUpdated?(favoritedBudgets.isEmpty)
        onSubscriptionsPlaceholderUpdated?(filteredSubscriptions.isEmpty)
        onPaymentsPlaceholderUpdated?(filteredPayments.isEmpty)
    }
    
    private func calculateTotalBudgetedThisMonth() {
        totalBudgets = budgets.reduce(0) { $0 + $1.totalAmount }
        totalPayments = payments.reduce(0) { $0 + $1.amount }
        totalSubscriptions = subscriptions.reduce(0) { $0 + $1.amount }
        
        totalBudgetedThisMonth = totalBudgets + totalPayments + totalSubscriptions
        preparePieChartData()
    }
    
    private func preparePieChartData() {
        let entries = [
            PieChartDataEntry(value: Double(round(100 * totalBudgets) / 100), label: "Budgets"),
            PieChartDataEntry(value: Double(round(100 * totalPayments) / 100), label: "Bank Payments"),
            PieChartDataEntry(value: Double(round(100 * totalSubscriptions) / 100), label: "Subscriptions")
        ]

        pieChartData = entries
    }
    
    private func loadFilteredOccurrences() {
        let subscriptionService = SubscriptionService(context: context)
        let paymentService = PaymentService(context: context)
        
        let allSubscriptionOccurrences = subscriptionService.fetchSubscriptionOccurrences()
        let allPaymentOccurrences = paymentService.fetchPaymentOccurrences()
        
        let now = Date()
        let filteredSubscriptions = allSubscriptionOccurrences.filter { $0.date >= now }
        let filteredPayments = allPaymentOccurrences.filter { $0.date >= now }
        
        self.filteredSubscriptions = Array(filteredSubscriptions.sorted(by: { $0.date < $1.date }).prefix(5))
        self.filteredPayments = Array(filteredPayments.sorted(by: { $0.date < $1.date }).prefix(4))
        notifyPlaceholders()
    }
    
    private func loadFavoritedBudgets() {
        loadBudgets()
        DataManager.shared.fetchFavoriteBudgets()
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = budgets.filter { favoriteCategories.contains($0.category.rawValue) }
        notifyPlaceholders()
        onFavoritedBudgetsUpdated?()
    }
    
    private func loadBudgets() {
        budgets = BasicExpenseService(context: DataManager.shared.context).fetchBasicExpenseBudgets()
        updateSpentAmounts()
    }
    
    private func updateSpentAmounts() {
        budgets.forEach { budget in
            if let category = BasicExpenseCategory(rawValue: budget.category.rawValue) {
                BasicExpenseService(context: DataManager.shared.context).recalculateSpentAmount(for: category)
            }
        }
        calculateTotalBudgetedThisMonth()
    }

    private func fetchSubscriptions() {
        DataManager.shared.fetchSubscriptionExpenses()
        subscriptions = DataManager.shared.subscriptionExpenseModelList
    }
    
    private func fetchPayments() {
        DataManager.shared.FetchPaymentExpenses()
        payments = DataManager.shared.PaymentExpenseModelList
    }
}

// MARK: - Delegate
extension DashboardViewModel: AddExpenseDelegate {
    func didAddExpense(_ expense: BasicExpenseModel) {
        loadFavoritedBudgets()
    }
}
