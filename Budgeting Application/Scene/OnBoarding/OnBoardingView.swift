//
//  OnBoarding.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 19.07.24.
//

import SwiftUI
import Lottie

struct OnBoarding: View {
    // MARK: Properties
    @State private var currentPage = 0
    @AppStorage("hasSeenOnBoarding") private var hasSeenOnBoarding: Bool = false
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    hasSeenOnBoarding = true
                } label: {
                    Text("Skip")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(Color(UIColor.infoViewColor))
                        )
                }
                .padding()
                .foregroundStyle(Color(UIColor.primaryTextColor))
            }
            
            Spacer()
            
            TabView(selection: $currentPage) {
                FirstPage().tag(0)
                SecondPage().tag(1)
                ThirdPage().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(currentPage == index ? Color(UIColor.infoViewColor) : Color.gray)
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }
            .padding(.bottom, 16)
            
            Button {
                if currentPage == 2 {
                    hasSeenOnBoarding = true
                } else {
                    currentPage += 1
                }
            } label: {
                Text(currentPage != 2 ? "Next" : "Get Started")
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.infoViewColor))
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
        }
        .onChange(of: hasSeenOnBoarding) { hasSeen in
                switchToLoginView()
        }
        .background(Color(UIColor.backgroundColor))
    }
    
    private func switchToLoginView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.switchToLoginView()
        }
    }
}

// MARK: - Extracted Views
struct FirstPage: View {
    var body: some View {
        VStack {
            LottieView(animation: .named("OnBoardingAnimation"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .resizable()
                .frame(height: 200)
            
            HStack {
                Text("Welcome to")
                    .font(.custom("ChesnaGrotesk-Bold", size: 24))
                    .padding([.leading, .top])
                
                Text("Budgeto.")
                    .foregroundStyle(Color(UIColor.NavigationRectangleColor))
                    .font(.custom("ChesnaGrotesk-Bold", size: 24))
                    .padding([.trailing, .top])
            }
            
            Text("Budgeto is a comprehensive application that helps you manage your finances efficiently.\nTrack your expenses, manage budgets, and stay on top of your financial goals.")
                .multilineTextAlignment(.leading)
                .font(.custom("ChesnaGrotesk-Medium", size: 18))
                .padding()
    
            Spacer()
        }
    }
}

struct SecondPage: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Main Page will provide you with a quick and easy access upcoming payments or budgets (Click on budgets to quickly add expenses)")
                .multilineTextAlignment(.leading)
                .padding()
                .font(.custom("ChesnaGrotesk-Medium", size: 12))
                .minimumScaleFactor(5)
                .foregroundStyle(Color(UIColor.primaryTextColor))

            HStack {
                HStack {
                        Image(colorScheme == .dark ? "OB-Dark" : "OB-White")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.height / 2)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 20,
                                topTrailingRadius: 20
                            )
                        )
                }
                
                VStack {
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(UIColor.infoViewColor))
                        
                        Text("Total Budgeted this month")
                            .frame(width: UIScreen.main.bounds.width / 2.5)
                            .multilineTextAlignment(.center)
                            .font(.custom("ChesnaGrotesk-Bold", size: 14))
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(UIColor.cellBackgroundColor))
                        
                        Text("Your five favorite budgets for easy access")
                            .font(.custom("ChesnaGrotesk-Regular", size: 12))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 2.5)
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.bottom, -60)
                    
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(UIColor.cellBackgroundColor))
                        
                        Text("Subscriptions that have to be payed soon ")
                            .font(.custom("ChesnaGrotesk-Regular", size: 12))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 2.5)
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.top, -5)
                    
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(UIColor.cellBackgroundColor))
                        
                        Text("Upcoming Bank Payments")
                            .frame(maxHeight: .infinity)
                            .font(.custom("ChesnaGrotesk-Regular", size: 12))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 2.5)
                    }
                    .padding(.top, -60)
                    
                }
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height / 1.9)
            
            Spacer()
        }
        .background(Color(UIColor.backgroundColor))
    }
}

struct ThirdPage: View {
    var body: some View {
        VStack {
            Text("Personalize")
                .font(.custom("ChesnaGrotesk-Bold", size: 36))
            Text("In the settings, you can customize the app by changing icons, updating your profile name, and deleting unnecessary data. For any questions questions or suggestions please contact us on our main app@budgeto.org")
                .font(.custom("ChesnaGrotesk-Medium", size: 16))
                .padding()
            Text("Make Budgeto your own.")
                .font(.custom("ChesnaGrotesk-Bold", size: 20))
                .foregroundStyle(Color(UIColor.infoViewColor))
            Spacer()
        }
        .background(Color(UIColor.backgroundColor))
    }
}
