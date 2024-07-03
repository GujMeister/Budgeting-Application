//
//  SubscriptionExpenseModel.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

import CoreData

@objc(SubscriptionExpenseModel)
class SubscriptionExpenseModel: NSManagedObject, Identifiable {
    @NSManaged public var category: String?
    @NSManaged public var subscriptionDescription: String?
    @NSManaged public var amount: Double
    @NSManaged public var startDate: Date?
    @NSManaged public var repeatCount: Int16
}
