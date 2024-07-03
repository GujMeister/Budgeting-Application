//
//  Subscription Occurances.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 01.07.24.
//

import Foundation
import CoreData

struct SubscriptionOccurrence {
    var category: String
    var subscriptionDescription: String
    var amount: Double
    var date: Date
}

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
