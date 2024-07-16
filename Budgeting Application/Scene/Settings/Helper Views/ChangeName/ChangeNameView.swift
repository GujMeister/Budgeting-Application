//
//  ChangeNameView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 16.07.24.
//

import SwiftUI

struct ChangeNameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newName = ""
    @AppStorage("userName") private var userName: String = ""

    var body: some View {
        VStack {
            TextField("Enter new name", text: $newName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Button(action: changeName) {
                Text("Change Name")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
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
