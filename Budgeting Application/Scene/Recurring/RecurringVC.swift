import SwiftUI
import CoreData

struct RecurringPage: View {
    @StateObject private var viewModel = RecurringPageViewModel()
    @State private var shouldAnimate = true
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
    ]
    
    var body: some View {
        VStack {
            ZStack {
                
                
                CustomSegmentedControlViewRepresentable(
                    color: .customLightBlue,
                    controlItems: ["Subscriptions", "Payments"],
                    defaultIndex: viewModel.selectedSegmentIndex,
                    segmentChangeCallback: { index in
                        viewModel.selectedSegmentIndex = index
                    },
                    shouldAnimate: $shouldAnimate
                )
                .frame(height: 60)
                .padding(.top, 195)
                
                NavigationRectangleRepresentable(
                    height: 0,
                    color: .customBlue,
                    totalBudgetedMoney: NumberFormatterHelper.shared.format(amount: viewModel.totalBudgeted, baseFont: UIFont(name: "Heebo-SemiBold", size: 36) ?? UIFont(), sizeDifference: 0.6),
                    descriptionLabelText: "Total Budgeted"
                )
                .edgesIgnoringSafeArea(.top)
                .frame(height: UIScreen.main.bounds.size.height / 5)
            }
            .edgesIgnoringSafeArea(.top)
            
            HStack {
                Menu {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation {
                                viewModel.selectedTimePeriod = period
                            }
                        }) {
                            Text(period.rawValue)
                        }
                    }
                } label: {
                    Text(viewModel.selectedTimePeriod.rawValue.uppercased())
                        .font(.headline)
                        .foregroundStyle(.black)
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Button(action: {
                    // Handle add action
                    if viewModel.selectedSegmentIndex == 0 {
                        presentAddSubscriptionVC()
                    } else {
                        presentAddPaymentVC()
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                }
            }
            .padding([.leading, .trailing])
            .padding(.top, -95)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    if viewModel.selectedSegmentIndex == 0 {
                        ForEach(viewModel.filteredSubscriptionOccurrences, id: \.date) { occurrence in
                            RecurringView(
                                emoji: SubscriptionCategory.emoji(for: occurrence.category),
                                amount: occurrence.amount,
                                paymentDescription: occurrence.subscriptionDescription,
                                date: occurrence.date
                            )
                        }
                    } else {
                        ForEach(viewModel.filteredPaymentOccurrences, id: \.date) { occurrence in
                            RecurringView(
                                emoji: PaymentsCategory.emoji(for: occurrence.category),
                                amount: occurrence.amount,
                                paymentDescription: occurrence.subscriptionDescription,
                                date: occurrence.date
                            )
                        }
                    }
                }
                .padding()
            }
            .padding(.top, -70)
        }
        .background(
            Color(UIColor.customBackground)
        )
        .onAppear {
            viewModel.loadOccurrences()
        }
    }
    
    private func presentAddSubscriptionVC() {
        let addSubscriptionVC = AddSubscriptionVC()
        addSubscriptionVC.delegate = viewModel as? any AddSubscriptionDelegate
        UIApplication.shared.windows.first?.rootViewController?.present(addSubscriptionVC, animated: true, completion: nil)
    }
    
    private func presentAddPaymentVC() {
        let addPaymentVC = AddPaymentVC()
        addPaymentVC.delegate = viewModel as? any AddPaymentDelegate
        UIApplication.shared.windows.first?.rootViewController?.present(addPaymentVC, animated: true, completion: nil)
    }
}

// MARK: - Payment Cell
struct RecurringView: View {
    var emoji: String
    var amount: Double
    var paymentDescription: String
    var date: Date
    var color: UIColor
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(paymentDescription)
                        .font(.custom("Heebo-SemiBold", size: 20))
                        .foregroundColor(.black)
                    
                    Text(PlainNumberFormatterHelper.shared.format(amount: amount))
                        .font(.custom("Inter-Regular", size: 15))
                        .foregroundStyle(.black)
                    
                    Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(UIColor.customLightBlue))
                        .padding([.trailing, .vertical] , -18)
                        .padding(.leading, 35)
                    Text(emoji)
                        .font(.system(size: 24))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .padding(.all, -5)
                        )
                }
                .padding(.trailing, -50)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
    }
}

// MARK: - Representables
struct CustomSegmentedControlViewRepresentable: UIViewRepresentable {
    var color: UIColor
    var controlItems: [String]
    var defaultIndex: Int
    var segmentChangeCallback: ((Int) -> Void)?
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> CustomSegmentedControlView {
        let view = CustomSegmentedControlView(color: color, controlItems: controlItems, defaultIndex: defaultIndex, segmentChangeCallback: segmentChangeCallback)
        if shouldAnimate {
            view.transform = CGAffineTransform(translationX: 0, y: -50)
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                view.transform = .identity
            }, completion: { _ in
                shouldAnimate = false
            })
        }
        return view
    }
    
    func updateUIView(_ uiView: CustomSegmentedControlView, context: Context) {
        uiView.setSelectedIndex(defaultIndex)
    }
}

struct NavigationRectangleRepresentable: UIViewRepresentable {
    let height: CGFloat
    let color: UIColor
    let totalBudgetedMoney: NSAttributedString
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
        uiView.totalBudgetedNumberLabel.attributedText = totalBudgetedMoney
    }
}

// MARK: - Preview
struct RecurringPage_Previews: PreviewProvider {
    static var previews: some View {
        RecurringPage()
        RecurringView(emoji: "🏠", amount: 1000, paymentDescription: "Vashlijvari", date: Date())
            .frame(width: UIScreen.main.bounds.width / 2, height: 150)
    }
}
