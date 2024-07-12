//
//  LoginView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 12.07.24.
//

import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: LoginPageViewModel

    @State private var passcode = ""
    @State private var isConfirmingPasscode = false
    @State private var topPasswordText = "Welcome"
    @State private var bottomPasswordText = "Create your 4-digit PIN to access your personal budgeting application"
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

            PasscodeIndicatorView(passcode: $passcode)

            Spacer()

            NumberPadView(passcode: $passcode)
                .onChange(of: passcode) { newPasscode in
                    if newPasscode.count == 4 {
                        handlePasscodeEntry(newPasscode)
                    }
                }
        }
        .padding()
        .onAppear {
            if viewModel.isPasscodeSet {
                topPasswordText = "Welcome back"
                bottomPasswordText = "Enter your 4-digit PIN to log in to your personal budgeting application"
            }
        }
    }

    private func handlePasscodeEntry(_ enteredPasscode: String) {
        if !viewModel.isPasscodeSet {
            if isConfirmingPasscode {
                if viewModel.temporaryPasscode == enteredPasscode {
                    viewModel.setPasscode(enteredPasscode)
                    switchToMainTabBar()
                } else {
                    isConfirmingPasscode = false
                    passcode = ""
                    topPasswordText = "Enter Passcode"
                }
            } else {
                viewModel.temporaryPasscode = enteredPasscode
                isConfirmingPasscode = true
                passcode = ""
                topPasswordText = "Confirm Passcode"
                bottomPasswordText = "Repeat Your Passcode"
            }
        } else {
            if viewModel.isPasscodeCorrect(enteredPasscode) {
                switchToMainTabBar()
            } else {
                passcode = ""
            }
        }
    }

    private func switchToMainTabBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.switchToMainTabBar()
        }
    }
}

#Preview {
    LoginView(viewModel: LoginPageViewModel())
}

// MARK: - Extracted Views
struct NumberPadView: View {
    // MARK: Properties
    @Binding var passcode: String

    private let columns: [GridItem] = [
        .init(),
        .init(),
        .init()
    ]

    // MARK: View
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(1...9, id: \.self) { index in
                Button {
                    addValue(index)
                } label: {
                    Text("\(index)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                }
            }

            Button {
                removeValue()
            } label: {
                Image(systemName: "delete.backward")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .contentShape(Rectangle())
            }

            Button {
                addValue(0)
            } label: {
                Text("0")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .contentShape(Rectangle())
            }
        }
        .foregroundStyle(.primary)
    }

    private func addValue(_ value: Int) {
        if passcode.count < 4 {
            passcode += "\(value)"
        }
    }

    private func removeValue() {
        if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
}

struct PasscodeIndicatorView: View {
    // MARK: Properties
    @Binding var passcode: String

    // MARK: View
    var body: some View {
        HStack(spacing: 32) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(passcode.count > index ? .primary : Color.white)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Circle()
                            .stroke(.black, lineWidth: 1.0)
                    }
            }
        }
    }
}
