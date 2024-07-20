//
//  ChangeNameView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 16.07.24.
//

import SwiftUI

struct ChangeNameView: View {
    // MARK: Properties
    @Environment(\.dismiss) var dismiss
    @State private var newName = ""
    @AppStorage("userName") private var userName: String = ""

    // MARK: - View
    var body: some View {
        VStack {
            Text(userName.isEmpty ? "You don't have a name set" : "Your current name is set to \"\(userName)\"")
                .font(.title2)
                .bold()
                .padding()
            
            TextField("Enter new name", text: $newName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action: changeName) {
                Text("Change Name")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(18)
            }
            .padding()
        }
        .padding()
    }

    private func changeName() {
        userName = newName
        dismiss()
    }
}

#Preview {
    ChangeNameView()
}
