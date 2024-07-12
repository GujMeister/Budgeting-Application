//
//  CalendarVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 11.07.24.
//

import CoreData

class CalendarViewModel {
    var onEventsUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }

    var expensesByDate: [Date: [BasicExpense]] = [:]
    var subscriptionsByDate: [Date: [SubscriptionOccurrence]] = [:]
    var paymentsByDate: [Date: [PaymentOccurrence]] = [:]
    var datesWithEvents: Set<Date> = []
    
    var selectedDateEvents: [Any] = []

    init() {
        loadEvents()
    }

    func loadEvents() {
        let expenseService = BasicExpenseService(context: context)
        let subscriptionService = SubscriptionService(context: context)
        let paymentService = PaymentService(context: context)

        let expenses = expenseService.fetchBasicExpenses()
        let subscriptions = subscriptionService.fetchSubscriptionOccurrences()
        let payments = paymentService.fetchPaymentOccurrences()
        
        expensesByDate = Dictionary(grouping: expenses, by: { Calendar.current.startOfDay(for: $0.date) })
        subscriptionsByDate = Dictionary(grouping: subscriptions, by: { Calendar.current.startOfDay(for: $0.date) })
        paymentsByDate = Dictionary(grouping: payments, by: { Calendar.current.startOfDay(for: $0.date) })
        
        datesWithEvents = Set(expensesByDate.keys)
            .union(subscriptionsByDate.keys)
            .union(paymentsByDate.keys)

        onEventsUpdated?()
    }

    func events(for date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        selectedDateEvents = (expensesByDate[startOfDay] ?? []) + (subscriptionsByDate[startOfDay] ?? []) + (paymentsByDate[startOfDay] ?? [])
        onEventsUpdated?()
    }

    var sections: [String] {
        var sections = [String]()
        if !selectedDateEvents.filter({ $0 is BasicExpense }).isEmpty {
            sections.append("Expenses")
        }
        if !selectedDateEvents.filter({ $0 is SubscriptionOccurrence }).isEmpty {
            sections.append("Subscriptions")
        }
        if !selectedDateEvents.filter({ $0 is PaymentOccurrence }).isEmpty {
            sections.append("Payments")
        }
        return sections
    }
}
