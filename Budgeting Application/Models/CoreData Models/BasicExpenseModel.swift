//
//  BasicExpenseModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData

//@objc(BasicExpenseModel)
class BasicExpenseModel: NSManagedObject, Identifiable {
    @NSManaged var amount: NSNumber!
    @NSManaged var category: String!
    @NSManaged var date: Date!
    @NSManaged var expenseDescription: String!
}
