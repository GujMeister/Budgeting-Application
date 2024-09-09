//
//  Payment Occurances.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

/// The `PaymentService` class is responsible for generating occurrences of payment expenses.
/// Each payment has a `repeatCount` and a `startDate`, which define how often the payment repeats over time.
///
/// This service iterates over the `repeatCount` value, generating a corresponding number of `PaymentOccurrence` objects.
/// Each occurrence represents a recurring charge for a subscription, spaced one month apart from the start date.
///
/// Example:
/// A subscription with a `repeatCount` of 12 will generate 12 occurrences, each one month apart from the `startDate`.

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
        
        let request = NSFetchRequest<PaymentExpenseModel>(entityName: "PaymentExpenseModel")
        
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
