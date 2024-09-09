//
//  BasicExpenseBudgetModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData

//@objc(BasicExpenseBudgetModel)
class BasicExpenseBudgetModel: NSManagedObject {
    @NSManaged var category: String!
    @NSManaged var spentAmount: NSNumber!
    @NSManaged var totalAmount: NSNumber!
}
