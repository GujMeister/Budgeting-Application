//
//  RecurringVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 05.07.24.
//

import CoreData

final class RecurringPageViewModel: ObservableObject {
    // MARK: - Properties
    private var allSubscriptionOccurrences: [SubscriptionOccurrence] = []
    private var allPaymentOccurrences: [PaymentOccurrence] = []
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    @Published var allSubscriptionExpenses: [SubscriptionExpense] = []
    @Published var allPaymentExpenses: [PaymentExpense] = []
    @Published var filteredSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var filteredPaymentOccurrences: [PaymentOccurrence] = []
    @Published var totalBudgeted: Double = 0.0
    @Published var listTotalBudgeted: Double = 0.0
    @Published var descriptionLabelText: String = ""
    
    @Published var selectedSegmentIndex: Int = 0 {
        didSet {
            loadOccurrences()
            updateDescriptionLabelText()
        }
    }
    
    @Published var selectedTimePeriod: TimePeriod = .thisMonth {
        didSet {
            filterOccurrences()
            updateDescriptionLabelText()
        }
    }
    
    // MARK: - Initialization
    init() {
        loadOccurrences()
        loadOverviewExpenses()
        updateDescriptionLabelText()
    }
    
    deinit {
        print("🗑️⬅️ Deiniting Recurring VIEWMODEL")
    }
    
    // MARK: - Overview
    func loadOverviewExpenses() {
        DataManager.shared.fetchSubscriptionExpenses()
        DataManager.shared.FetchPaymentExpenses()
        
        allSubscriptionExpenses = DataManager.shared.subscriptionExpenseModelList.map { subscription in
            SubscriptionExpense(
                category: SubscriptionCategory(rawValue: subscription.category!)!,
                subscriptionDescription: subscription.subscriptionDescription ?? "",
                amount: subscription.amount,
                startDate: subscription.startDate!,
                repeatCount: Int(subscription.repeatCount)
            )
        }
        
        allPaymentExpenses = DataManager.shared.PaymentExpenseModelList.map { payment in
            PaymentExpense(
                category: PaymentsCategory(rawValue: payment.category!)!,
                paymentDescription: payment.paymentDescription ?? "",
                amount: payment.amount,
                startDate: payment.startDate!,
                repeatCount: Int(payment.repeatCount)
            )
        }
        
        listTotalBudgeted = allSubscriptionExpenses.reduce(0) { $0 + $1.amount } +
        allPaymentExpenses.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: Deleting
    func deleteSubscriptionExpense(_ subscription: SubscriptionExpense) {
        if let index = allSubscriptionExpenses.firstIndex(where: { $0.subscriptionDescription == subscription.subscriptionDescription }) {
            allSubscriptionExpenses.remove(at: index)
            // Also remove from CoreData
            if let coreDataSubscription = DataManager.shared.subscriptionExpenseModelList.first(where: { $0.subscriptionDescription == subscription.subscriptionDescription }) {
                DataManager.shared.deleteSubscriptionExpense(expense: coreDataSubscription)
            }
        }
    }
    
    func deletePaymentExpense(_ payment: PaymentExpense) {
        if let index = allPaymentExpenses.firstIndex(where: { $0.paymentDescription == payment.paymentDescription }) {
            allPaymentExpenses.remove(at: index)
            // Also remove from CoreData
            if let coreDataPayment = DataManager.shared.PaymentExpenseModelList.first(where: { $0.paymentDescription == payment.paymentDescription }) {
                DataManager.shared.deletePaymentExpense(expense: coreDataPayment)
            }
        }
    }
    
    // MARK: - Occurancies Functions
    private func loadOccurrences() {
        loadSubscriptions()
        loadPayments()
        filterOccurrences()
    }
    
    private func loadSubscriptions() {
        let service = SubscriptionService(context: context)
        allSubscriptionOccurrences = service.fetchSubscriptionOccurrences()
        filterOccurrences()
    }
    
    private func loadPayments() {
        let service = PaymentService(context: context)
        allPaymentOccurrences = service.fetchPaymentOccurrences()
        filterOccurrences()
    }
    
    func totalBudgetedMoneyHelper() -> Double {
        if selectedSegmentIndex == 2 {
            return listTotalBudgeted
        } else {
            return totalBudgeted
        }
    }
    
    private func filterOccurrences() {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimePeriod {
        case .thisWeek:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < endOfWeek }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfWeek && $0.date < endOfWeek }
        case .thisTwoWeeks:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let twoWeeksFromNow = calendar.date(byAdding: .day, value: 14, to: startOfWeek) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < twoWeeksFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfWeek && $0.date < twoWeeksFromNow }
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfMonth && $0.date < endOfMonth }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfMonth && $0.date < endOfMonth }
        case .threeMonths:
            let threeMonthsFromNow = calendar.date(byAdding: .month, value: 3, to: now) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= now && $0.date <= threeMonthsFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= now && $0.date <= threeMonthsFromNow }
        case .sixMonths:
            let sixMonthsFromNow = calendar.date(byAdding: .month, value: 6, to: now) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= now && $0.date <= sixMonthsFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= now && $0.date <= sixMonthsFromNow }
        case .year:
            let yearFromNow = calendar.date(byAdding: .year, value: 1, to: now) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= now && $0.date <= yearFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= now && $0.date <= yearFromNow }
        }
        
        
        DispatchQueue.main.async {
            self.totalBudgeted = self.calculateTotalBudgeted()
        }
    }
    
    private func calculateTotalBudgeted() -> Double {
        if selectedSegmentIndex == 0 {
            return filteredSubscriptionOccurrences.reduce(0) { $0 + $1.amount }
        } else {
            return filteredPaymentOccurrences.reduce(0) { $0 + $1.amount }
        }
    }
    
    private func updateDescriptionLabelText() {
        if selectedSegmentIndex == 2 {
            descriptionLabelText = "Total Monthly Expenditure"
        } else {
            let segmentName = selectedSegmentIndex == 0 ? "Subscriptions" : "Bank Payments"
            descriptionLabelText = "\(segmentName) Left: \(selectedTimePeriod.rawValue)"
        }
    }
    
    private func savePayment(_ payment: PaymentExpense) {
        let context = DataManager.shared.context
        let paymentModel = PaymentExpenseModel(context: context)
        
        paymentModel.category = payment.category.rawValue
        paymentModel.paymentDescription = payment.paymentDescription
        paymentModel.amount = payment.amount
        paymentModel.startDate = payment.startDate
        paymentModel.repeatCount = Int16(payment.repeatCount)
        
        do {
            try context.save()
        } catch {
            print("Failed to save payment: \(error)")
        }
        
        loadOccurrences()
        loadOverviewExpenses()
        updateDescriptionLabelText()
    }
    
    private func saveSubscription(_ payment: SubscriptionExpense) {
        let context = DataManager.shared.context
        let subscriptionModel = SubscriptionExpenseModel(context: context)
        
        subscriptionModel.category = payment.category.rawValue
        subscriptionModel.subscriptionDescription = payment.subscriptionDescription
        subscriptionModel.amount = payment.amount
        subscriptionModel.startDate = payment.startDate
        subscriptionModel.repeatCount = Int16(payment.repeatCount)
        
        do {
            try context.save()
        } catch {
            print("Failed to save payment: \(error)")
        }
        
        loadOccurrences()
        loadOverviewExpenses()
        updateDescriptionLabelText()
    }
}

// MARK: - Delegate - AddPaymentDelegate
extension RecurringPageViewModel: AddPaymentDelegate {
    func didAddPayment(_ payment: PaymentExpense) {
        savePayment(payment)
    }
}

// MARK: - Delegate - AddSubscriptionDelegate
extension RecurringPageViewModel: AddSubscriptionDelegate {
    func didAddSubscription(_ subscription: SubscriptionExpense) {
        saveSubscription(subscription)
    }
}
