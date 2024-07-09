//
//  DashboardVM.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData

import CoreData

// MARK: - DashboardViewModel
class DashboardViewModel {
    // MARK: - Properties
    var budgets: [BasicExpenseBudget] = []
    var subscriptions: [SubscriptionExpenseModel] = []
    var payments: [PaymentExpenseModel] = []
    
    // MARK: Data To Show
    var filteredSubscriptions: [SubscriptionOccurrence] = [] {
        didSet {
            onSubscriptionsUpdated?()
        }
    }
    
    var filteredPayments: [PaymentOccurance] = [] {
        didSet {
            onPaymentsUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var totalBudgetedThisMonth: Double = 0.0 {
        didSet {
            onTotalBudgetedThisMonthUpdated?()
        }
    }

    var onTotalBudgetedThisMonthUpdated: (() -> Void)?
    var onFavoritedBudgetsUpdated: (() -> Void)?
    var onSubscriptionsUpdated: (() -> Void)?
    var onPaymentsUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    // MARK: - Initialization
    init() {
        fetchFavoritedBudgets()
        fetchPayments()
        fetchSubscriptions()
        calculateTotalBudgetedThisMonth()
        loadFilteredOccurrences()
    }
    
    deinit {
        print("🗑️⬅️ Deiniting Dashboard VIEWMODEL")
    }
    
    func loadData() {
        fetchSubscriptions()
        fetchPayments()
        fetchFavoritedBudgets()
        calculateTotalBudgetedThisMonth()
        loadFilteredOccurrences()
    }
    
    func calculateTotalBudgetedThisMonth() {
        let totalBudgeted = budgets.reduce(0) { $0 + $1.totalAmount }
        let totalPayments = payments.reduce(0) { $0 + $1.amount }
        let totalSubscriptions = subscriptions.reduce(0) { $0 + $1.amount }

        totalBudgetedThisMonth = totalBudgeted + totalPayments + totalSubscriptions
    }
    
    func loadFilteredOccurrences() {
        let subscriptionService = SubscriptionService(context: context)
        let paymentService = PaymentService(context: context)
        
        let allSubscriptionOccurrences = subscriptionService.fetchSubscriptionOccurrences()
        let allPaymentOccurrences = paymentService.fetchPaymentOccurrences()
        
        let now = Date()
        let filteredSubscriptions = allSubscriptionOccurrences.filter { $0.date >= now }
        let filteredPayments = allPaymentOccurrences.filter { $0.date >= now }
        
        self.filteredSubscriptions = Array(filteredSubscriptions.sorted(by: { $0.date < $1.date }).prefix(5))
        self.filteredPayments = Array(filteredPayments.sorted(by: { $0.date < $1.date }).prefix(4))
    }
    
    // MARK: - Budgets
    func fetchFavoritedBudgets() {
        loadBudgets()
        DataManager.shared.fetchFavoriteBudgets()
        
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = budgets.filter { favoriteCategories.contains($0.category.rawValue) }
        onFavoritedBudgetsUpdated?()
    }
    
    func loadBudgets() {
        let service = BasicExpenseService(context: context)
        budgets = service.fetchBasicExpenseBudgets()
    }

    // MARK: - Subscriptions
    func fetchSubscriptions() {
        DataManager.shared.fetchSubscriptionExpenses()
        subscriptions = DataManager.shared.subscriptionExpenseModelList
    }
    
    // MARK: - Payments
    func fetchPayments() {
        DataManager.shared.FetchPaymentExpenses()
        payments = DataManager.shared.PaymentExpenseModelList
    }
}
