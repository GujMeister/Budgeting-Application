//
//  BasicExpenseModel.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import CoreData

@objc(BasicExpenseModel)
class BasicExpenseModel: NSManagedObject {
    @NSManaged var amount: NSNumber!
    @NSManaged var category: String!
    @NSManaged var date: Date!
    @NSManaged var expenseDescription: String!
}
