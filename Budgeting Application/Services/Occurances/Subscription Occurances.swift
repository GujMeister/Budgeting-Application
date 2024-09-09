//
//  Subscription Occurances.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 01.07.24.
//

/// The `SubscriptionService` class is responsible for generating occurrences of subscription expenses.
/// Each subscription has a `repeatCount` and a `startDate`, which define how often the subscription repeats over time.
///
/// This service iterates over the `repeatCount` value, generating a corresponding number of `SubscriptionOccurrence` objects.
/// Each occurrence represents a recurring charge for a subscription, spaced one month apart from the start date.
///
/// Example:
/// A subscription with a `repeatCount` of 12 will generate 12 occurrences, each one month apart from the `startDate`.

import CoreData

final class SubscriptionService {
    // MARK: - Context
    private var context: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Methods
    func fetchSubscriptionOccurrences() -> [SubscriptionOccurrence] {
        var occurrences: [SubscriptionOccurrence] = []
        
        let request = NSFetchRequest<SubscriptionExpenseModel>(entityName: "SubscriptionExpenseModel")
        
        do {
            let subscriptions = try context.fetch(request)
            
            for subscription in subscriptions {
                if let startDate = subscription.startDate {
                    for i in 0..<subscription.repeatCount {
                        if let newDate = Calendar.current.date(byAdding: .month, value: Int(i), to: startDate) {
                            let occurrence = SubscriptionOccurrence(
                                category: subscription.category ?? "Unknown",
                                subscriptionDescription: subscription.subscriptionDescription ?? "No Description",
                                amount: subscription.amount,
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
