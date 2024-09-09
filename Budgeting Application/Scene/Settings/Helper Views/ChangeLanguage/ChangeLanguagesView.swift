//
//  ChangeLanguagesView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 31.08.24.
//

import SwiftUI

struct ChangeLanguagesView: View {
    @StateObject private var viewModel = ChangeLanguagesViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Text("choose_language".translated())
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 40)
                .accessibilityLabel("choose_language".translated())

            VStack(spacing: 20) {
                Button {
                    viewModel.setLanguage("en")
                    dismiss()
                } label: {
                    Text("English")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.NavigationRectangleColor))
                        .cornerRadius(20)
                        .accessibilityLabel("English")
                }

                Button {
                    viewModel.setLanguage("ka")
                    dismiss()
                } label: {
                    Text("ქართული")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.NavigationRectangleColor))
                        .cornerRadius(20)
                        .accessibilityLabel("ქართული")
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ChangeLanguagesView()
}
