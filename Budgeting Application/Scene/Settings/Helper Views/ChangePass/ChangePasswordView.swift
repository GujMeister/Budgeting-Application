//
//  ChangePasswordView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 16.07.24.
//

import SwiftUI

struct ChangePasswordView: View {
    // MARK: Properties
    @ObservedObject var viewModel: ChangePasswordViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isConfirmingPasscode = false
    @State private var topPasswordText = "Change Password"
    @State private var bottomPasswordText = "Enter your new 4-digit PIN"
    @State private var showText = false
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 48) {
            VStack(spacing: 24) {
                Text(topPasswordText)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .opacity(showText ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            showText = true
                        }
                    }
                
                Text(bottomPasswordText)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            PasscodeIndicatorView(passcode: $newPassword)
            
            Spacer()
            
            NumberPadView(passcode: $newPassword)
                .onChange(of: newPassword) { differentPass in
                    if newPassword.count == 4 {
                        handlePasscodeEntry(newPassword)
                    }
                }
        }
        .padding()
        .onAppear {
            if viewModel.isPasscodeSet {
                topPasswordText = "Change Password"
                bottomPasswordText = "Enter your new 4-digit PIN"
            }
        }
    }
    
    // MARK: - Helper functions
    private func handlePasscodeEntry(_ enteredPasscode: String) {
        if isConfirmingPasscode {
            if newPassword == enteredPasscode {
                viewModel.setPasscode(enteredPasscode)
                dismiss()
            } else {
                isConfirmingPasscode = false
                newPassword = ""
                topPasswordText = "Enter New Passcode"
                bottomPasswordText = "Pins did not match. Try again."
            }
        } else {
            confirmPassword = enteredPasscode
            isConfirmingPasscode = true
            newPassword = ""
            topPasswordText = "Confirm Passcode"
            bottomPasswordText = "Repeat Your New Passcode"
        }
    }
}

#Preview {
    ChangePasswordView(viewModel: ChangePasswordViewModel())
}
