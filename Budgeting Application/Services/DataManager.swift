//
//  DataManager.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData
import UIKit

final class DataManager {
    // MARK: - Properties
    static let shared = DataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Delete Records
    func deleteAllRecords() {
        deleteAll(entityName: "SubscriptionExpenseModel")
        deleteAll(entityName: "BasicExpenseBudgetModel")
        deleteAll(entityName: "BasicExpenseModel")
        deleteAll(entityName: "PaymentExpenseModel")
        deleteAll(entityName: "FavoriteBudgetsModel")
    }
    
    func deleteBasicExpenses() {
        deleteAll(entityName: "BasicExpenseModel")
    }

    func deleteSubscriptionExpenses() {
        deleteAll(entityName: "SubscriptionExpenseModel")
    }

    func deletePaymentExpenses() {
        deleteAll(entityName: "PaymentExpenseModel")
    }
    
    private func deleteAll(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Failed to delete records for entity \(entityName): \(error)")
        }
    }

    // MARK: - FavoriteBudgetsModel Management
    var favoriteBudgets: [FavoriteBudgetsModel] = []

    func fetchFavoriteBudgets() {
        let request = NSFetchRequest<FavoriteBudgetsModel>(entityName: "FavoriteBudgetsModel")
        do {
            favoriteBudgets = try context.fetch(request)
        } catch {
            print("Failed to fetch FavoriteBudgetsModel: \(error)")
        }
    }

    func addFavoriteBudget(category: String) {
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteBudgetsModel", in: context)!
        let favorite = FavoriteBudgetsModel(entity: entity, insertInto: context)
        favorite.category = category
        saveContext()
    }

    func removeFavoriteBudget(category: String) {
        let request = NSFetchRequest<FavoriteBudgetsModel>(entityName: "FavoriteBudgetsModel")
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                context.delete(favorite)
            }
            saveContext()
        } catch {
            print("Failed to remove FavoriteBudgetsModel: \(error)")
        }
    }
    
    // MARK: - SubscriptionExpenseModel Management
    var subscriptionExpenseModelList: [SubscriptionExpenseModel] = []

    func fetchSubscriptionExpenses() {
        let request = NSFetchRequest<SubscriptionExpenseModel>(entityName: "SubscriptionExpenseModel")
        do {
            subscriptionExpenseModelList = try context.fetch(request)
        } catch {
            print("Failed to fetch SubscriptionExpenseModel: \(error)")
        }
    }

    func addSubscriptionExpense(category: String, amount: Double, startDate: Date, repeatCount: Int16, subscriptionDescription: String) {
        let entity = NSEntityDescription.entity(forEntityName: "SubscriptionExpenseModel", in: context)!
        let subscription = SubscriptionExpenseModel(entity: entity, insertInto: context)
        subscription.category = category
        subscription.amount = amount
        subscription.startDate = startDate
        subscription.repeatCount = repeatCount
        subscription.subscriptionDescription = subscriptionDescription
        saveContext()
    }

    func deleteSubscriptionExpense(expense: SubscriptionExpenseModel) {
        context.delete(expense)
        saveContext()
    }
    
    // MARK: - PaymentExpenseModel Management
    var PaymentExpenseModelList: [PaymentExpenseModel] = []

    func FetchPaymentExpenses() {
        let request = NSFetchRequest<PaymentExpenseModel>(entityName: "PaymentExpenseModel")
        do {
            PaymentExpenseModelList = try context.fetch(request)
        } catch {
            print("Failed to fetch PaymentExpenseModel: \(error)")
        }
    }

    func addPaymentExpense(category: String, amount: Double, startDate: Date, repeatCount: Int16, paymentDescription: String) {
        let entity = NSEntityDescription.entity(forEntityName: "PaymentExpenseModel", in: context)!
        let payment = PaymentExpenseModel(entity: entity, insertInto: context)
        payment.category = category
        payment.amount = amount
        payment.startDate = startDate
        payment.repeatCount = repeatCount
        payment.paymentDescription = paymentDescription
        saveContext()
    }

    func deletePaymentExpense(expense: PaymentExpenseModel) {
        context.delete(expense)
        saveContext()
    }

    // MARK: - BasicExpenseBudgetModel Management
    var basicExpenseBudgetModelList: [BasicExpenseBudgetModel] = []
    
    func fetchBasicExpenseBudgets() {
        let request = NSFetchRequest<BasicExpenseBudgetModel>(entityName: "BasicExpenseBudgetModel")
        do {
            basicExpenseBudgetModelList = try context.fetch(request)
        } catch {
            print("Failed to fetch BasicExpenseBudgetModel: \(error)")
        }
    }
    
    func addBasicExpenseBudget(category: String, spentAmount: NSNumber, totalAmount: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "BasicExpenseBudgetModel", in: context)!
        let expense = BasicExpenseBudgetModel(entity: entity, insertInto: context)
        expense.category = category
        expense.spentAmount = spentAmount
        expense.totalAmount = totalAmount
        saveContext()
    }
    
    func deleteBasicExpenseBudget(expense: BasicExpenseBudgetModel) {
        context.delete(expense)
        saveContext()
    }
    
    // MARK: - BasicExpenseModel Management
    var basicExpenseModelList: [BasicExpenseModel] = []
    
    func fetchBasicExpenses() {
        let request = NSFetchRequest<BasicExpenseModel>(entityName: "BasicExpenseModel")
        do {
            basicExpenseModelList = try context.fetch(request)
        } catch {
            print("Failed to fetch BasicExpenseModel: \(error)")
        }
    }
    
    func addBasicExpense(category: String, amount: NSNumber, date: Date, expenseDescription: String) {
        let entity = NSEntityDescription.entity(forEntityName: "BasicExpenseModel", in: context)!
        let expense = BasicExpenseModel(entity: entity, insertInto: context)
        expense.category = category
        expense.amount = amount
        expense.date = date
        expense.expenseDescription = expenseDescription
        saveContext()
    }

    func deleteBasicExpense(expense: BasicExpenseModel) {
        context.delete(expense)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
