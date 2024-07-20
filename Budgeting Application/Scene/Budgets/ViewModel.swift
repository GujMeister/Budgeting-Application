//
//  BudgetsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import CoreData

final class BudgetsViewModel: NSObject {
    // MARK: Properties
    var onBudgetsUpdated: (() -> Void)?
    var onFavoritedBudgetsUpdated: (() -> Void)?
    var onExpensesUpdated: (() -> Void)?
    var onTotalBudgetedMoneyUpdated: (() -> Void)?
    var onTotalExpensesUpdated: (() -> Void)?
    var onExpensesDescriptionUpdated: ((String) -> Void)?
    var showAlertForDuplicateCategory: (() -> Void)?
    var showAlertForMaxFavorites: (() -> Void)?
    
    // BudgetsVC
    var totalBudgetedMoney: Double = 0.0 {
        didSet {
            onTotalBudgetedMoneyUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var allBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onBudgetsUpdated?()
            onTotalBudgetedMoneyUpdated?()
        }
    }
    
    // ExpensesVC
    var expensesByDate: [Date: [BasicExpense]] = [:]
    
    var totalExpenses: Double = 0.0 {
        didSet {
            onTotalExpensesUpdated?()
        }
    }
    
    var expenses: [BasicExpense] = [] {
        didSet {
            onExpensesUpdated?()
        }
    }
    
    // Additional Variables
    var sortedExpenseDates: [Date] {
        return expensesByDate.keys.sorted(by: >)
    }
    
    var selectedTimePeriod: TimePeriodBackwards = .lastMonth {
        didSet {
            filterExpenses()
            updateExpensesDescription()
        }
    }
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    static let shared = BudgetsViewModel()
    private var service: BasicExpenseService
    
    // MARK: - Lifecycle
    override init() {
        self.service = BasicExpenseService(context: DataManager.shared.context)
        super.init()
        loadBudgets()
        loadFavoritedBudgets()
        loadExpenses()
    }
    
    // MARK: - Methods
    // Budgets
    func loadBudgets() {
        allBudgets = service.fetchBasicExpenseBudgets()
        updateTotalBudgetedMoney()
        allBudgets.forEach { budget in
            if let category = BasicExpenseCategory(rawValue: budget.category.rawValue) {
                service.recalculateSpentAmount(for: category)
            }
        }
    }
    
    private func updateTotalBudgetedMoney() {
        totalBudgetedMoney = allBudgets.reduce(0) { $0 + $1.totalAmount }
    }
    
    func loadFavoritedBudgets() {
        DataManager.shared.fetchFavoriteBudgets()
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = allBudgets.filter { favoriteCategories.contains($0.category.rawValue) }
        onFavoritedBudgetsUpdated?()
    }
    
    func addBudgetToFavorites(_ budget: BasicExpenseBudget) {
        if favoritedBudgets.count < 5 {
            DataManager.shared.addFavoriteBudget(category: budget.category.rawValue)
            loadFavoritedBudgets()
        } else {
            showAlertForMaxFavorites?()
        }
    }
    
    func removeBudgetFromFavorites(_ budget: BasicExpenseBudget) {
        DataManager.shared.removeFavoriteBudget(category: budget.category.rawValue)
        loadFavoritedBudgets()
    }
    
    func deleteBudget(at index: Int) {
        let budgetToDelete = allBudgets[index]
        service.deleteBasicExpenseBudget(by: budgetToDelete.category.rawValue)
        allBudgets.remove(at: index)
        removeBudgetFromFavorites(budgetToDelete)
        loadFavoritedBudgets()
        updateTotalBudgetedMoney()
    }
    
    func isBudgetFavorited(_ budget: BasicExpenseBudget) -> Bool {
        return favoritedBudgets.contains(where: { $0.category == budget.category })
    }
    
    // MARK: - Expenses
    func addExpense(_ expense: BasicExpenseModel) {
        service.addExpense(expense)
        loadExpenses()
    }
    
    func loadExpenses() {
        expenses = service.fetchBasicExpenses()
        filterExpenses()
    }
    
    func deleteExpense(at indexPath: IndexPath) {
        let date = sortedExpenseDates[indexPath.section]
        if var expensesForDate = expensesByDate[date] {
            let expenseToDelete = expensesForDate[indexPath.row]
            service.deleteBasicExpense(expense: expenseToDelete)
            expensesForDate.remove(at: indexPath.row)
            expensesByDate[date] = expensesForDate.isEmpty ? nil : expensesForDate
            loadExpenses()
        }
    }
    
    func filterExpenses() {
        let calendar = Calendar.current
        let now = Date()
        var filtered: [BasicExpense] = []
        
        switch selectedTimePeriod {
        case .today:
            let startOfToday = calendar.startOfDay(for: now)
            filtered = expenses.filter { $0.date >= startOfToday }
        case .lastThreeDays:
            let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now) ?? now
            filtered = expenses.filter { $0.date >= threeDaysAgo }
        case .lastWeek:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            filtered = expenses.filter { $0.date >= weekAgo }
        case .lastMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            filtered = expenses.filter { $0.date >= monthAgo }
        }
        
        expensesByDate = Dictionary(grouping: filtered) { expense in
            calendar.startOfDay(for: expense.date)
        }
        
        totalExpenses = filtered.reduce(0) { $0 + $1.amount }
        
        DispatchQueue.main.async {
            self.onExpensesUpdated?()
        }
    }
    
    func updateExpensesDescription() {
        let description: String
        switch selectedTimePeriod {
        case .today:
            description = "Expenses Today"
        case .lastThreeDays:
            description = "Expenses Last 3 Days"
        case .lastWeek:
            description = "Expenses Last Week"
        case .lastMonth:
            description = "Expenses Last Month"
        }
        onExpensesDescriptionUpdated?(description)
    }
}

// MARK: - Delegate - BudgetDetailViewControllerDelegate
extension BudgetsViewModel: BudgetDetailViewControllerDelegate {
    func didUpdateFavoriteStatus(for budget: BasicExpenseBudget) {
        if isBudgetFavorited(budget) {
            removeBudgetFromFavorites(budget)
        } else if favoritedBudgets.count < 5 {
            addBudgetToFavorites(budget)
        } else {
            showAlertForMaxFavorites?()
        }
    }
}

// MARK: - Delegate - AddBudgetsDelegate
extension BudgetsViewModel: AddBudgetsDelegate {
    func addCategory(_ category: BasicExpenseCategory, totalAmount: Double) {
        if checkForDuplicateCategory(category) {
            showAlertForDuplicateCategory?()
            return
        }
        
        let newBudget = BasicExpenseBudgetModel(context: DataManager.shared.context)
        newBudget.category = category.rawValue
        newBudget.totalAmount = NSNumber(value: totalAmount)
        newBudget.spentAmount = 0
        
        do {
            try DataManager.shared.context.save()
            loadBudgets()
        } catch {
            print("Failed to save new budget: \(error)")
        }
    }
    
    func checkForDuplicateCategory(_ category: BasicExpenseCategory) -> Bool {
        return allBudgets.contains { $0.category == category }
    }
}

// MARK: - Delegate - AddExpenseDelegate
extension BudgetsViewModel: AddExpenseDelegate {
    func didAddExpense(_ expense: BasicExpenseModel) {
        loadBudgets()
        loadFavoritedBudgets()
        loadExpenses()
    }
}
