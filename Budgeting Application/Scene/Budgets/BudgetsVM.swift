//
//  BudgetsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import Foundation
import CoreData

enum TimePeriodBackwards: String, CaseIterable {
    case lastDay = "Last Day"
    case lastThreeDays = "Last 3 Days"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
}

class BudgetsViewModel {
    var allBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onBudgetsUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var onBudgetsUpdated: (() -> Void)?
    var onFavoritedBudgetsUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    init() {
        loadBudgets()
        loadFavoritedBudgets()
    }
    
    func loadBudgets() {
        let service = BasicExpenseService(context: context)
        allBudgets = service.fetchBasicExpenseBudgets()
    }
    
    func loadFavoritedBudgets() {
        if let savedBudgets = UserDefaults.standard.object(forKey: "favoritedBudgets") as? Data {
            let decoder = JSONDecoder()
            if let loadedBudgets = try? decoder.decode([BasicExpenseBudget].self, from: savedBudgets) {
                favoritedBudgets = loadedBudgets
            }
        }
    }
    
    func saveFavoritedBudgets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoritedBudgets) {
            UserDefaults.standard.set(encoded, forKey: "favoritedBudgets")
            onFavoritedBudgetsUpdated?()
        }
    }
    
    func addBudgetToFavorites(_ budget: BasicExpenseBudget) {
        favoritedBudgets.append(budget)
        saveFavoritedBudgets()
    }
    
    func removeBudgetFromFavorites(_ budget: BasicExpenseBudget) {
        favoritedBudgets.removeAll { $0.category == budget.category }
        saveFavoritedBudgets()
    }
}
