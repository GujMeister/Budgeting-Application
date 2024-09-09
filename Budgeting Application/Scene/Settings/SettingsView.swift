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
                        
                        Text("settings_title".translated())
                            .font(.largeTitle)
                            .bold()
                            .accessibilityLabel("settings_title".translated())
                        
                        Text("settings_description".translated())
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.bottom)
                            .accessibilityLabel("settings_description".translated())
                    }
                    
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            
            Button {
                viewModel.showAboutView = true
            } label: {
                HStack {
                    Text("about".translated())
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("about_accessibility".translated())
                .accessibilityHint("about_accessibility_hint".translated())
            }
            .sheet(isPresented: $viewModel.showAboutView) {
                AboutView()
            }
            
            Section(header: Text("delete_section".translated()).accessibilityLabel("delete_section".translated())) {
                Button {
                    viewModel.deleteBasicExpenses()
                } label: {
                    HStack {
                        Text("delete_expenses".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("delete_expenses_accessibility".translated())
                    .accessibilityHint("delete_expenses_accessibility_hint".translated())
                }
                
                Button {
                    viewModel.deleteSubscriptionExpenses()
                } label: {
                    HStack {
                        Text("delete_subscriptions".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("delete_subscriptions_accessibility".translated())
                    .accessibilityHint("delete_subscriptions_accessibility_hint".translated())
                }
                
                Button {
                    viewModel.deletePaymentExpenses()
                } label: {
                    HStack {
                        Text("delete_payments".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("delete_payments_accessibility".translated())
                    .accessibilityHint("delete_payments_accessibility_hint".translated())
                }
                
                Button {
                    viewModel.deleteAllData()
                } label: {
                    HStack {
                        Text("delete_all_data".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("delete_all_data_accessibility".translated())
                    .accessibilityHint("delete_all_data_accessibility_hint".translated())
                }
            }
            
            Section {
                Button {
                    viewModel.showChangePasswordView = true
                } label: {
                    HStack {
                        Text("change_password".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("change_password_accessibility".translated())
                    .accessibilityHint("change_password_accessibility_hint".translated())
                }
                .sheet(isPresented: $viewModel.showChangePasswordView) {
                    ChangePasswordView(viewModel: ChangePasswordViewModel())
                }
                
                
                Button {
                    viewModel.showChangeIcon = true
                } label: {
                    HStack {
                        Text("change_app_icon".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("change_app_icon_accessibility".translated())
                    .accessibilityHint("change_app_icon_accessibility_hint".translated())
                }
                .sheet(isPresented: $viewModel.showChangeIcon) {
                    ChangeIconView()
                }
                
                Button {
                    viewModel.showChangeLanguage = true
                } label: {
                    HStack {
                        Text("change_language".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("change_language_accessibility".translated())
                    .accessibilityHint("change_language_accessibility_hint".translated())
                }
                .sheet(isPresented: $viewModel.showChangeLanguage) {
                    ChangeLanguagesView()
                }
                
                Button {
                    viewModel.showChangeNameView = true
                } label: {
                    HStack {
                        Text("change_name".translated())
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("change_name_accessibility".translated())
                    .accessibilityHint("change_name_accessibility_hint".translated())
                }
                .sheet(isPresented: $viewModel.showChangeNameView) {
                    ChangeNameView()
                }
            }
            
            Section {
                Text("app_version".translated())
                    .accessibilityLabel("app_version".translated())
                Text("rights_reserved".translated())
                    .accessibilityLabel("rights_reserved".translated())
            } header: {
                Text("app_information_header".translated()).accessibilityLabel("app_information_header".translated())
            } footer: {
                Text("app_information_footer".translated())
                    .foregroundStyle(Color(UIColor.systemGray2))
                    .accessibilityLabel("app_information_footer".translated())
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
