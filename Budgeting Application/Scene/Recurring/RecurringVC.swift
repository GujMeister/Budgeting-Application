
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
                Text(subscriptionDescription)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 5)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .padding([.top, .trailing], 5)
                    Text(categoryEmoji)
                        .font(.system(size: 8))
                        .padding([.top, .trailing], 5)
                }
            }
            .padding([.trailing, .top], -18)
            
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
        SubscriptionView(categoryEmoji: "⭐️", amount: 9.99, subscriptionDescription: "Spotify", date: .now)
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
