//
//  Subscription Occurances.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

// Documentation:
// Subscription expense model has 2 properties named repeat count and date
// SubscriptionService makes as many Subscription Occurrance objects as there are "repeat counts" on the subscription
// If subscription expense has 12 repeat count on specific date, this service produces 12 objects on dates 1 month apart

import CoreData

class SubscriptionService {
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchSubscriptionOccurrences() -> [SubscriptionOccurrence] {
        var occurrences: [SubscriptionOccurrence] = []
        
        let request: NSFetchRequest<SubscriptionExpenseModel> = SubscriptionExpenseModel.fetchRequest() as! NSFetchRequest<SubscriptionExpenseModel>
        
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
