import SwiftUI
import CoreData

class RecurringPageViewModel: ObservableObject {
    @Published var allSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var filteredSubscriptionOccurrences: [SubscriptionOccurrence] = []
    @Published var selectedTimePeriod: TimePeriod = .thisMonth {
        didSet {
            filterSubscriptions()
        }
    }
    @Published var totalBudgeted: Double = 0.0

    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    init() {
        loadSubscriptions()
    }
    
    func loadSubscriptions() {
        let service = SubscriptionService(context: context)
        allSubscriptionOccurrences = service.fetchSubscriptionOccurrences()
//        print("Loaded subscriptions: \(allSubscriptionOccurrences)")
        filterSubscriptions()
    }
    
    func filterSubscriptions() {
        let calendar = Calendar.current
        let now = Date()
        let filteredOccurrences: [SubscriptionOccurrence]
        
        switch selectedTimePeriod {
        case .thisWeek:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < endOfWeek }
//            print("Filtered occurrences for this week: \(filteredOccurrences)")
        case .thisTwoWeeks:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let twoWeeksFromNow = calendar.date(byAdding: .day, value: 14, to: startOfWeek) ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfWeek && $0.date < twoWeeksFromNow }
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date >= startOfMonth && $0.date < endOfMonth }
        case .threeMonths:
            let threeMonthsFromNow = calendar.date(byAdding: .month, value: 3, to: now) ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date <= threeMonthsFromNow }
        case .sixMonths:
            let sixMonthsFromNow = calendar.date(byAdding: .month, value: 6, to: now) ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date <= sixMonthsFromNow }
        case .year:
            let yearFromNow = calendar.date(byAdding: .year, value: 1, to: now) ?? now
            filteredOccurrences = allSubscriptionOccurrences.filter { $0.date <= yearFromNow }
        }
        
        func calculateTotalBudgeted() -> Double {
            return filteredSubscriptionOccurrences.reduce(0) { $0 + $1.amount }
        }
        
        DispatchQueue.main.async {
            self.filteredSubscriptionOccurrences = filteredOccurrences
            self.totalBudgeted = calculateTotalBudgeted()
//            print("Total budgeted: \(self.totalBudgeted)")
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

