import SwiftUI
import CoreData

class RecurringPageViewModel: ObservableObject {
    @Published var allSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var allPaymentOccurrences: [PaymentOccurance] = []
    @Published var filteredSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var filteredPaymentOccurrences: [PaymentOccurance] = []
    @Published var totalBudgeted: Double = 0.0
    @Published var listTotalBudgeted: Double = 0.0
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
    
    @Published var descriptionLabelText: String = ""
    
    // MARK: - Combined Properties
    @Published var allSubscriptionExpenses: [SubscriptionExpense] = []
    @Published var allPaymentExpenses: [PaymentExpense] = []
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    // MARK: - Initialization
    init() {
        loadOccurrences()
        loadAllExpenses()
        updateDescriptionLabelText()
    }
    
    // MARK: - Overview View Functions
    func loadAllExpenses() {
        DataManager.shared.fetchSubscriptionExpenses()
        DataManager.shared.PaymentExpenses()
        
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
    func loadOccurrences() {
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
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= threeMonthsFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= threeMonthsFromNow }
        case .sixMonths:
            let sixMonthsFromNow = calendar.date(byAdding: .month, value: 6, to: now) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= sixMonthsFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= sixMonthsFromNow }
        case .year:
            let yearFromNow = calendar.date(byAdding: .year, value: 1, to: now) ?? now
            filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= yearFromNow }
            filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= yearFromNow }
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
            descriptionLabelText = "\(segmentName) Budgeted: \(selectedTimePeriod.rawValue)"
        }
    }
}


enum TimePeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisTwoWeeks = "This Two Weeks"
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
}
