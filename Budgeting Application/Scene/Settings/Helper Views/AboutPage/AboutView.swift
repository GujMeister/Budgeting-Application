//
//  AboutView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import SwiftUI

struct AboutView: View {
    // MARK:  View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About Budgeto.")
                    .font(.title).bold()
                    .padding(.bottom, 8)

                Text("Budgeto is a comprehensive personal finance application designed to help you manage your finances effortlessly. Our mission is to provide users with a powerful tool to track their expenses, manage subscriptions, plan budgets, and stay on top of their financial goals.")

                Text("Key Features")
                    .font(.title2).bold()
                    .padding(.top, 16)

                FeatureListItem(icon: "house.fill", text: "Dashboard: Get an overview of your financial status with real-time updates on your expenses, income, and budget performance.")
                FeatureListItem(icon: "repeat", text: "Recurring Expenses: Easily manage your recurring expenses, such as subscriptions and bill payments. Keep track of due dates and avoid late fees.")
                FeatureListItem(icon: "book.closed.fill", text: "Budgets: Create and manage multiple budgets to ensure you stay within your financial limits. Categorize your expenses and see where your money goes.")
                FeatureListItem(icon: "calendar", text: "Calendar: View your financial activities on a calendar to get a clear picture of your spending habits over time. Track due dates for bills and subscriptions.")
                FeatureListItem(icon: "gearshape.fill", text: "Settings: Customize your app experience, change your passcode, update your personal information, and more.")
                FeatureListItem(icon: "square.grid.2x2.fill", text: "Customizable App Icons: Personalize your app with different icons to match your style.")

                Text("Security and Privacy")
                    .font(.title2).bold()
                    .padding(.top, 16)

                Text("At Budgeto, we take your privacy and security seriously. Your data is securely stored and never shared with third parties without your consent. Use our app with confidence, knowing that your financial information is protected.")

                Text("Support")
                    .font(.title2).bold()
                    .padding(.top, 16)

                Text("We are committed to providing the best user experience. If you have any questions, feedback, or need assistance, please reach out to our support team through the app or visit our website.")

                Text("Thank you for choosing Budgeto to manage your finances. We hope it helps you achieve your financial goals and provides you with peace of mind.")
                    .padding(.top, 16)
            }
            .padding()
        }
    }
}

// MARK: - Extracted View
struct FeatureListItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
            Text(text)
        }
    }
}

#Preview {
    AboutView()
}
