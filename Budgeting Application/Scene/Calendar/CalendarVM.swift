//
//  CalendarVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 11.07.24.
//

import CoreData

final class CalendarViewModel {
    // MARK: - Properties
    var onEventsUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    internal var expensesByDate: [Date: [BasicExpense]] = [:]
    internal var subscriptionsByDate: [Date: [SubscriptionOccurrence]] = [:]
    internal var paymentsByDate: [Date: [PaymentOccurrence]] = [:]
    internal var datesWithEvents: Set<Date> = []
    internal var selectedDateEvents: [Any] = []
    
    // MARK: - Initialization
    init() {
        loadEvents()
    }
    
    // MARK: - Methods
    internal func loadEvents() {
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
    
    internal func events(for date: Date) {
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
