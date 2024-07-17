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
        Form {
            Section {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .padding(10)
                            .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(UIColor.systemGray))
                            )
                            .padding(.top)
                        
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Manage or delete your data, read about the app and change password, app icons or name")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14))
                            .padding(.bottom)
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
            }
            .sheet(isPresented: $viewModel.showAboutView) {
                AboutView()
            }
            
            Section(header: Text("Delete")) {
                Button {
                    viewModel.deleteBasicExpenses()
                } label: {
                    HStack {
                        Text("Expenses")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Button {
                    viewModel.deleteSubscriptionExpenses()
                } label: {
                    HStack {
                        Text("Subscriptions")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Button {
                    viewModel.deletePaymentExpenses()
                } label: {
                    HStack {
                        Text("Bank Payments")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Button {
                    viewModel.deleteAllData()
                } label: {
                    HStack {
                        Text("All Data")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
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
                }
                .sheet(isPresented: $viewModel.showChangeNameView) {
                    ChangeNameView()
                }
            }
            
            Section {
                Text("Version 2.2")
                Text("© All Rights Reserved")
            } header: {
                Text("App")
            } footer: {
                Text("Owner of this application gives all the rights imaginable regarding the usage of his assets and code used in this application")
                    .foregroundStyle(Color(UIColor.systemGray2))
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
