//
//  Payment Occurances.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import CoreData

struct PaymentOccurance {
    var category: String
    var subscriptionDescription: String
    var amount: Double
    var date: Date
}

class PaymentService {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchPaymentOccurrences() -> [PaymentOccurance] {
        var occurrences: [PaymentOccurance] = []
        
        let request: NSFetchRequest<PaymentExpenseModel> = PaymentExpenseModel.fetchRequest() as! NSFetchRequest<PaymentExpenseModel>
        
        do {
            let payments = try context.fetch(request)
            
            for payment in payments {
                if let startDate = payment.startDate {
                    for i in 0..<payment.repeatCount {
                        if let newDate = Calendar.current.date(byAdding: .month, value: Int(i), to: startDate) {
                            let occurrence = PaymentOccurance(
                                category: payment.category ?? "Unknown",
                                subscriptionDescription: payment.paymentDescription ?? "No Description",
                                amount: payment.amount,
                                date: newDate
                            )
                            occurrences.append(occurrence)
                        }
                    }
                }
            }
        } catch {
            print("Failed to fetch SubscriptionExpenseModel: \(error)")
        }
        
        return occurrences
    }
}
