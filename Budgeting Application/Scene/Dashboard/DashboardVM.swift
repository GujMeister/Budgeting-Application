//
//  DashboardVM.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData

// MARK: - DashboardViewModel
class DashboardViewModel {
    // MARK: - Properties
    var budgets: [BasicExpenseBudget] = [] {
        didSet {
            onBudgetsUpdated?()
        }
    }
    
    var subscriptions: [SubscriptionExpenseModel] = [] {
        didSet {
            onSubscriptionsUpdated?()
        }
    }
    
    var payments: [PaymentExpenseModel] = [] {
        didSet {
            print(payments)
            onPaymentsUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }

    var onBudgetsUpdated: (() -> Void)?
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
    }
    
    deinit {
        print("Deiniting DashboardVIEWMODEL ")
    }
    
    // MARK: - Load All Data
    func loadData() {
        fetchSubscriptions()
        fetchPayments()
        fetchFavoritedBudgets()
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
