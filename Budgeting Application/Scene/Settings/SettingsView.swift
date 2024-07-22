//
//  SettingsVC.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 15.07.24.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Properties
    @StateObject private var viewModel = SettingsVM()
    
    // MARK: - View
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(UIColor.systemGray))
                            )
                            .padding(.top)
                            .accessibilityHidden(true)
                        
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                            .accessibilityLabel("Settings")
                        
                        Text("Manage or delete your data, read about the app and change password, app icons or name")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.bottom)
                            .accessibilityLabel("Manage or delete your data, read about the app and change password, app icons or name")
                    }
                    
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            
            Button {
                viewModel.showAboutView = true
            } label: {
                HStack {
                    Text("About")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("About the app")
                .accessibilityHint("Tap to read about the app")
            }
            .sheet(isPresented: $viewModel.showAboutView) {
                AboutView()
            }
            
            Section(header: Text("Delete").accessibilityLabel("Delete data")) {
                Button {
                    viewModel.deleteBasicExpenses()
                } label: {
                    HStack {
                        Text("Expenses")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Delete expenses")
                    .accessibilityHint("Tap to delete all expenses")
                }
                
                Button {
                    viewModel.deleteSubscriptionExpenses()
                } label: {
                    HStack {
                        Text("Subscriptions")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Delete subscriptions")
                    .accessibilityHint("Tap to delete all subscriptions")
                }
                
                Button {
                    viewModel.deletePaymentExpenses()
                } label: {
                    HStack {
                        Text("Bank Payments")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Delete bank payments")
                    .accessibilityHint("Tap to delete all bank payments")
                }
                
                Button {
                    viewModel.deleteAllData()
                } label: {
                    HStack {
                        Text("All Data")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Delete all data")
                    .accessibilityHint("Tap to delete all data")
                }
            }
            
            Section {
                Button {
                    viewModel.showChangePasswordView = true
                } label: {
                    HStack {
                        Text("Change Password")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Change password")
                    .accessibilityHint("Tap to change your password")
                }
                .sheet(isPresented: $viewModel.showChangePasswordView) {
                    ChangePasswordView(viewModel: ChangePasswordViewModel())
                }
                
                
                Button {
                    viewModel.showChangeIcon = true
                } label: {
                    HStack {
                        Text("Change App Icon")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Change app icon")
                    .accessibilityHint("Tap to change the app icon")
                }
                .sheet(isPresented: $viewModel.showChangeIcon) {
                    ChangeIconView()
                }
                
                
                Button {
                    viewModel.showChangeNameView = true
                } label: {
                    HStack {
                        Text("Change Name")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Change app name")
                    .accessibilityHint("Tap to change the app name")
                }
                .sheet(isPresented: $viewModel.showChangeNameView) {
                    ChangeNameView()
                }
            }
            
            Section {
                Text("Version 2.2")
                    .accessibilityLabel("App version 2.2")
                Text("© All Rights Reserved")
                    .accessibilityLabel("All rights reserved")
            } header: {
                Text("App").accessibilityLabel("App information")
            } footer: {
                Text("Owner of this application gives all the rights imaginable regarding the usage of his assets and code used in this application")
                    .foregroundStyle(Color(UIColor.systemGray2))
                    .accessibilityLabel("Owner of this application gives all the rights imaginable regarding the usage of his assets and code used in this application")
            }
        }
        .padding(.top, -30)
        .foregroundColor(Color(UIColor.label))
        .background(
            SwiftUIViewController(alert: viewModel.alert)
                .frame(width: 0, height: 0)
        )
    }
}

#Preview {
    SettingsView()
}
