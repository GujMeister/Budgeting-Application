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
}
