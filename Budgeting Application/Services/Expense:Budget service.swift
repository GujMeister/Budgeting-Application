//
//  Expense:Budget service.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import CoreData

class BasicExpenseService {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func startOfCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now))
    }
    
    func fetchBasicExpenses() -> [BasicExpense] {
        var expenses: [BasicExpense] = []
        
        let request: NSFetchRequest<BasicExpenseModel> = BasicExpenseModel.fetchRequest() as! NSFetchRequest<BasicExpenseModel>
        
        do {
            let coreDataExpenses = try context.fetch(request)
            
            for coreDataExpense in coreDataExpenses {
                if let categoryString = coreDataExpense.category,
                   let category = BasicExpenseCategory(rawValue: categoryString) {
                    let expense = BasicExpense(
                        category: category,
                        expenseDescription: coreDataExpense.expenseDescription ?? "No Description",
                        amount: coreDataExpense.amount.doubleValue,
                        date: coreDataExpense.date ?? Date()
                    )
                    expenses.append(expense)
                }
            }
        } catch {
            print("Failed to fetch BasicExpenseModel: \(error)")
        }
        
        return expenses
    }
    
    func fetchBasicExpenseBudgets() -> [BasicExpenseBudget] {
        var budgets: [BasicExpenseBudget] = []
        
        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
        
        do {
            let coreDataBudgets = try context.fetch(request)
            
            for coreDataBudget in coreDataBudgets {
                if let categoryString = coreDataBudget.category,
                   let category = BasicExpenseCategory(rawValue: categoryString) {
                    let budget = BasicExpenseBudget(
                        category: category,
                        totalAmount: coreDataBudget.totalAmount.doubleValue,
                        spentAmount: coreDataBudget.spentAmount.doubleValue
                    )
                    budgets.append(budget)
                }
            }
        } catch {
            print("Failed to fetch BasicExpenseBudgetModel: \(error)")
        }
        
        return budgets
    }
    
    func addExpense(_ expense: BasicExpenseModel) {
        context.insert(expense)
        
        // Update the budget for the expense category
        updateBudget(for: expense)
        
        do {
            try context.save()
        } catch {
            print("Failed to save expense: \(error)")
        }
    }
    
    func deleteBasicExpense(expense: BasicExpense) {
        let request: NSFetchRequest<BasicExpenseModel> = BasicExpenseModel.fetchRequest() as! NSFetchRequest<BasicExpenseModel>
        request.predicate = NSPredicate(format: "expenseDescription == %@ AND date == %@", expense.expenseDescription, expense.date as NSDate)

        do {
            let coreDataExpenses = try context.fetch(request)
            if let expenseToDelete = coreDataExpenses.first {
                // Update the budget before deleting the expense:
                updateBudget(for: expenseToDelete, isDeleting: true)

                context.delete(expenseToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }

    private func updateBudget(for expense: BasicExpenseModel, isDeleting: Bool = false) {
        guard let categoryString = expense.category,
              let category = BasicExpenseCategory(rawValue: categoryString),
              let startOfMonth = startOfCurrentMonth() else {
            return
        }

        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)

        do {
            let budgets = try context.fetch(request)
            if let budget = budgets.first {
                // Fetch all expenses for the category from the start of the month
                let expenseRequest: NSFetchRequest<BasicExpenseModel> = BasicExpenseModel.fetchRequest() as! NSFetchRequest<BasicExpenseModel>
                expenseRequest.predicate = NSPredicate(format: "category == %@ AND date >= %@", category.rawValue, startOfMonth as NSDate)
                let expenses = try context.fetch(expenseRequest)
                
                // Calculate the total spent amount for the category from the start of the month
                let totalSpent = expenses.reduce(0) { $0 + $1.amount.doubleValue }
                
                if isDeleting {
                    budget.spentAmount = NSNumber(value: totalSpent - expense.amount.doubleValue)
                } else {
                    budget.spentAmount = NSNumber(value: totalSpent + expense.amount.doubleValue)
                }

                // Save the updated budget to Core Data
                try context.save()
            }
        } catch {
            print("Failed to fetch or update budget for category \(category.rawValue): \(error)")
        }
    }
    
    // MARK: - Budgets
//    private func updateBudget(for expense: BasicExpenseModel) {
//        guard let categoryString = expense.category,
//              let category = BasicExpenseCategory(rawValue: categoryString) else {
//            return
//        }
//        
//        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
//        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
//        
//        do {
//            let budgets = try context.fetch(request)
//            if let budget = budgets.first {
//                budget.spentAmount = NSNumber(value: budget.spentAmount.doubleValue + expense.amount.doubleValue)
//                
//                // Save updated budgets to UserDefaults
//                saveUpdatedBudgets()
//            }
//        } catch {
//            print("Failed to fetch budget for category \(category.rawValue): \(error)")
//        }
//    }
    
    func recalculateSpentAmount(for category: BasicExpenseCategory) {
        guard let startOfMonth = startOfCurrentMonth() else { return }
        
        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)

        do {
            let budgets = try context.fetch(request)
            if let budget = budgets.first {
                // Fetch all expenses for the category from the start of the month
                let expenseRequest: NSFetchRequest<BasicExpenseModel> = BasicExpenseModel.fetchRequest() as! NSFetchRequest<BasicExpenseModel>
                expenseRequest.predicate = NSPredicate(format: "category == %@ AND date >= %@", category.rawValue, startOfMonth as NSDate)
                let expenses = try context.fetch(expenseRequest)
                
                // Calculate the total spent amount for the category from the start of the month
                let totalSpent = expenses.reduce(0) { $0 + $1.amount.doubleValue }
                budget.spentAmount = NSNumber(value: totalSpent)
                
                // Save the updated budget to Core Data
                try context.save()
            }
        } catch {
            print("Failed to fetch or update budget for category \(category.rawValue): \(error)")
        }
    }
    
    private func saveUpdatedBudgets() {
        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
        
        do {
            let budgets = try context.fetch(request)
            let updatedBudgets = budgets.map { budget in
                return BasicExpenseBudget(
                    category: BasicExpenseCategory(rawValue: budget.category)!,
                    totalAmount: budget.totalAmount.doubleValue,
                    spentAmount: budget.spentAmount.doubleValue
                )
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(updatedBudgets) {
                UserDefaults.standard.set(encoded, forKey: "favoritedBudgets")
            }
        } catch {
            print("Failed to fetch budgets: \(error)")
        }
    }
    
    func deleteBasicExpenseBudget(by category: String) {
        let request: NSFetchRequest<BasicExpenseBudgetModel> = BasicExpenseBudgetModel.fetchRequest() as! NSFetchRequest<BasicExpenseBudgetModel>
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let budgets = try context.fetch(request)
            if let budgetToDelete = budgets.first {
                context.delete(budgetToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete budget for category \(category): \(error)")
        }
    }
}
