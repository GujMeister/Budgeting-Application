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
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var subscriptions: [SubscriptionExpenseModel] = [] {
        didSet {
            onSubscriptionsUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var onFavoritedBudgetsUpdated: (() -> Void)?
    var onSubscriptionsUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    // MARK: - Initialization
    init() {
        loadBudgets()
        loadFavoritedBudgets()
    }
    
    deinit {
        print("Deiniting DashboardVIEWMODEL ")
    }
    
    // MARK: - Budgets
    func loadFavoritedBudgets() {
        DataManager.shared.fetchFavoriteBudgets()
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = budgets.filter { favoriteCategories.contains($0.category.rawValue) }
        onFavoritedBudgetsUpdated?()
    }
    
    func loadBudgets() {
        let service = BasicExpenseService(context: context)
        budgets = service.fetchBasicExpenseBudgets()
    }
    
    func fetchBudgets() {
        DataManager.shared.fetchBasicExpenseBudgets()
        budgets = DataManager.shared.basicExpenseBudgetModelList.compactMap { coreDataBudget in
            guard let category = BasicExpenseCategory(rawValue: coreDataBudget.category) else {
                return nil
            }
            
            return BasicExpenseBudget(
                category: category,
                totalAmount: coreDataBudget.totalAmount.doubleValue,
                spentAmount: coreDataBudget.spentAmount.doubleValue
            )
        }
    }
    
    // MARK: - Subscriptions
    func fetchSubscriptions() {
        DataManager.shared.fetchSubscriptionExpenses()
        subscriptions = DataManager.shared.subscriptionExpenseModelList
    }
}
