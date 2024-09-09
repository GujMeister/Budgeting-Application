//
//  PaymentExpenseModel.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import CoreData

//@objc(PaymentExpenseModel)
class PaymentExpenseModel: NSManagedObject, Identifiable {
    @NSManaged public var category: String?
    @NSManaged public var paymentDescription: String?
    @NSManaged public var amount: Double
    @NSManaged public var startDate: Date?
    @NSManaged public var repeatCount: Int16
}
