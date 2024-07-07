import SwiftUI
import CoreData

class RecurringPageViewModel: ObservableObject {
    @Published var allSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var allPaymentOccurrences: [PaymentOccurance] = []
    @Published var filteredSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var filteredPaymentOccurrences: [PaymentOccurance] = []
    @Published var selectedTimePeriod: TimePeriod = .thisMonth {
        didSet {
            filterOccurrences()
        }
    }
    @Published var totalBudgeted: Double = 0.0
    @Published var selectedSegmentIndex: Int = 0 {
        didSet {
            loadOccurrences()
        }
    }

    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    init() {
        loadOccurrences()
    }
    
    func loadOccurrences() {
        if selectedSegmentIndex == 0 {
            loadSubscriptions()
        } else {
            loadPayments()
        }
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
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < endOfWeek }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfWeek && $0.date < endOfWeek }
            }
        case .thisTwoWeeks:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let twoWeeksFromNow = calendar.date(byAdding: .day, value: 14, to: startOfWeek) ?? now
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < twoWeeksFromNow }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfWeek && $0.date < twoWeeksFromNow }
            }
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfMonth && $0.date < endOfMonth }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date >= startOfMonth && $0.date < endOfMonth }
            }
        case .threeMonths:
            let threeMonthsFromNow = calendar.date(byAdding: .month, value: 3, to: now) ?? now
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= threeMonthsFromNow }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= threeMonthsFromNow }
            }
        case .sixMonths:
            let sixMonthsFromNow = calendar.date(byAdding: .month, value: 6, to: now) ?? now
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= sixMonthsFromNow }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= sixMonthsFromNow }
            }
        case .year:
            let yearFromNow = calendar.date(byAdding: .year, value: 1, to: now) ?? now
            if selectedSegmentIndex == 0 {
                filteredSubscriptionOccurrences = allSubscriptionOccurrences.filter { $0.date <= yearFromNow }
            } else {
                filteredPaymentOccurrences = allPaymentOccurrences.filter { $0.date <= yearFromNow }
            }
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
}

enum TimePeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisTwoWeeks = "This Two Weeks"
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
}
