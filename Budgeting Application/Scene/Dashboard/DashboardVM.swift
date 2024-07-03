//
//  DashboardVM.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

// MARK: - DashboardViewModel
class DashboardViewModel {
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
    
    var onBudgetsUpdated: (() -> Void)?
    var onSubscriptionsUpdated: (() -> Void)?
    
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
    
    func fetchSubscriptions() {
        DataManager.shared.fetchSubscriptionExpenses()
        subscriptions = DataManager.shared.subscriptionExpenseModelList
    }
}
