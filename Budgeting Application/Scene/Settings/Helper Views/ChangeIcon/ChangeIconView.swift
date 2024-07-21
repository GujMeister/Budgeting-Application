//
//  ChangeIconView.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 17.07.24.
//

import SwiftUI

struct ChangeIconView: View {
    // MARK: Properties
    @StateObject private var viewModel = ChangeIconViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Text("Change App Icon")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
            }
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.icons, id: \.self) { icon in
                    Button(action: {
                        viewModel.changeAppIcon(to: icon == "default" ? nil : icon)
                    }) {
                        VStack {
                            Image(uiImage: UIImage(named: icon + ".png") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(UIColor.systemGray), lineWidth: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(viewModel.currentIcon == icon ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            Text(icon)
                                .foregroundStyle(Color(UIColor.label))
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            
            
            Button {
                viewModel.resetIcon()
            } label: {
                Text("Reset Icon")
                    .foregroundStyle(Color(UIColor.label))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(UIColor.systemGray4))
                    )
                
            }
            .padding()
        }
    }
}

#Preview {
    ChangeIconView()
}
