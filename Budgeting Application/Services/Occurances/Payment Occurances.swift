//
//  Payment Occurances.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

// Documentation:
// Payment expense model has 2 properties named repeat count and date
// PaymentService makes as many Payment Occurrance objects as there are "repeat counts" on the payment
// If payment expense has 12 repeat count on specific date, this service produces 12 objects on dates 1 month apart

import CoreData

final class PaymentService {
    // MARK: - Properties
    private var context: NSManagedObjectContext
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Methods
    func fetchPaymentOccurrences() -> [PaymentOccurrence] {
        var occurrences: [PaymentOccurrence] = []
        
        let request: NSFetchRequest<PaymentExpenseModel> = PaymentExpenseModel.fetchRequest() as! NSFetchRequest<PaymentExpenseModel>
        
        do {
            let payments = try context.fetch(request)
            
            for payment in payments {
                if let startDate = payment.startDate {
                    for i in 0..<payment.repeatCount {
                        if let newDate = Calendar.current.date(byAdding: .month, value: Int(i), to: startDate) {
                            let occurrence = PaymentOccurrence(
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
            print("Failed to fetch PaymentExpenseModel: \(error)")
        }
        
        return occurrences
    }
    
    //Widget Kit
    func fetchTopTwoUpcomingPayments() -> [PaymentOccurrence] {
        let allOccurrences = fetchPaymentOccurrences()
        let upcomingOccurrences = allOccurrences.filter { $0.date >= Date() }
        let sortedOccurrences = upcomingOccurrences.sorted { $0.date < $1.date }
        return Array(sortedOccurrences.prefix(2))
    }
}
