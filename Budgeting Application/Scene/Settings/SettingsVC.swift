//
//  SettingsVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsVM()
    

    var body: some View {
        VStack {
            HStack {
                Text("Back")
                Spacer()
                Text("Settings")
                    .font(.title)
                    .bold()
                Spacer()
                Text("Back")
                    .foregroundStyle(.white)
            }
            .padding()

            Button {
                // About action
            } label: {
                HStack {
                    Text("About")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Button {
                // Version action
            } label: {
                HStack {
                    Text("Version")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Text("Delete")

            Button {
                viewModel.deleteBasicExpenses()
            } label: {
                HStack {
                    Text("Delete Expenses")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Button {
                viewModel.deleteSubscriptionExpenses()
            } label: {
                HStack {
                    Text("Delete Subscriptions")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Button {
                viewModel.deletePaymentExpenses()
            } label: {
                HStack {
                    Text("Delete Bank Payments")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Button {
                viewModel.deleteAllData()
            } label: {
                HStack {
                    Text("Delete All Data")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Text("Password")

            Button {
                viewModel.showChangePasswordView = true
            } label: {
                HStack {
                    Text("Change Password")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            .sheet(isPresented: $viewModel.showChangePasswordView) {
                ChangePasswordView(viewModel: ChangePasswordViewModel())
            }

            Text("Name")

            Button {
                viewModel.showChangeNameView = true
            } label: {
                HStack {
                    Text("Add/Change Name")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            .sheet(isPresented: $viewModel.showChangeNameView) {
                ChangeNameView()
            }

            Spacer()
        }
        .background(
            SwiftUIViewController(alert: viewModel.alert)
                .frame(width: 0, height: 0)
        )
    }
}


#Preview {
    SettingsView()
}
