
import SwiftUI
import CoreData

struct RecurringPage: View {
    @StateObject private var viewModel = RecurringPageViewModel()
    @State private var showDropdown = false
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
    
    var body: some View {
        VStack {
            NavigationRectangleRepresentable(
                height: 212.667,
                color: .blue,
                totalBudgetedMoney: String(format: "$%.2f", viewModel.totalBudgeted),
                descriptionLabelText: "Total Budgeted"
            )
                .edgesIgnoringSafeArea(.top)
                .frame(height: UIScreen.main.bounds.size.height / 7.41)
            
            VStack {
                HStack {
                    Text(viewModel.selectedTimePeriod.rawValue.uppercased())
                        .font(.headline)
                        .padding()
                    Spacer()
                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                        .padding()
                }
                .onTapGesture {
                    withAnimation {
                        showDropdown.toggle()
                    }
                }
                
                if showDropdown {
                    VStack {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Text(period.rawValue)
//                                .padding()
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedTimePeriod = period
                                        showDropdown = false
                                    }
                                }
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding([.leading, .trailing], 10)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.filteredSubscriptionOccurrences, id: \.date) { occurrence in
                        SubscriptionView(
                            categoryEmoji: SubscriptionCategory.emoji(for: occurrence.category),
                            amount: occurrence.amount,
                            subscriptionDescription: occurrence.subscriptionDescription,
                            date: occurrence.date
                        )
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadSubscriptions()
        }
    }
}

struct SubscriptionView: View {
    var categoryEmoji: String
    var amount: Double
    var subscriptionDescription: String
    var date: Date
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                    Text(categoryEmoji)
                        .font(.title)
                }
            }
            .padding([.trailing, .top], -18)
            
            Text(subscriptionDescription)
                .font(.system(size: 13))
                .foregroundColor(.black)
            
            Text(String(format: "$%.2f", amount))
                .font(.system(size: 10))
                .foregroundStyle(.black)
            
            Text(DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
    }
}

// MARK: - Preview
struct RecurringPage_Previews: PreviewProvider {
    static var previews: some View {
        RecurringPage()
    }
}

struct NavigationRectangleRepresentable: UIViewRepresentable {
    let height: CGFloat
    let color: UIColor
    let totalBudgetedMoney: String
    let descriptionLabelText: String
    
    func makeUIView(context: Context) -> NavigationRectangle {
        return NavigationRectangle(
            height: height,
            color: color,
            totalBudgetedMoney: totalBudgetedMoney,
            descriptionLabelText: descriptionLabelText
        )
    }
    
    func updateUIView(_ uiView: NavigationRectangle, context: Context) {
        uiView.totalBudgetedNumberLabel.text = totalBudgetedMoney
    }
}
