//
//  IntroPageViewController.swift
//  Tugz
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

struct OnboardingViewPure: View {
    
    @ObservedObject var onboarding: Onboarding
    
    @State var slideGesture: CGSize = CGSize.zero
    
    @Environment(\.presentationMode) var presentationMode

    var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    init(onboarding: Onboarding) {
        
        self.onboarding = onboarding
        onboarding.view = self
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .center) {
                
                ForEach(onboarding.pages, id: \.self) { page in
                    OnboardingSubview(page: page, onboarding: onboarding)
                        .offset(x: CGFloat(page.rawValue) * screenWidth)
                        .offset(x: slideGesture.width - CGFloat(onboarding.currentPage.rawValue) * screenWidth)
//                        .animation(.spring(), value: offset) // ???
                        .animation(.spring())
                        .gesture(DragGesture().onChanged{ value in
                            slideGesture = value.translation
                        }
                        .onEnded { value in
                            if slideGesture.width < -50 {
                                onboarding.goToNextPage()
                            }
                            if slideGesture.width > 50 {
                                if onboarding.currentPage.rawValue > 0 {
                                    withAnimation {
                                        onboarding.updatePage(onboarding.currentPage.rawValue - 1)
                                    }
                                }
                            }
                            slideGesture = .zero
                        })
                }
            }
            
            LinearGradient(colors: [.white.opacity(0), .white], startPoint: UnitPoint(x: 0, y: 0.6), endPoint: UnitPoint(x: 0, y: 1))
                .opacity(onboarding.currentPageGradientOpacity)
                .allowsHitTesting(false)
            
            VStack {
                Spacer()
                HStack {
                    progressView()
                    Spacer()
                    
                    if onboarding.currentPage.showsNextButton {
                        Button(action: onboarding.goToNextPage) {
                            arrowView()
                        }
                    }
                }
            }
            .padding(20)
        }
    }
    
    func arrowView() -> some View {
        Group {
            if onboarding.currentPage.rawValue == onboarding.pages.count - 1 {
                HStack {
                    Text("Done")
                        .font(.system(size: 27, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemBackground))
                }
                .frame(width: 120, height: 50)
                .background(Color(.label))
                .cornerRadius(25)
            } else {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .scaledToFit()
                    .frame(width: 50)
            }
        }
    }
    
    func progressView() -> some View {
        HStack {
            ForEach(0..<onboarding.pages.count, id: \.self) { i in
                Circle()
                    .scaledToFit()
                    .frame(width: 10)
                    .foregroundColor(onboarding.currentPage.rawValue >= i ? .accentColor : Color(.systemGray))
            }
        }
    }
    
}

struct OnboardingViewPure_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingViewPure(onboarding: Onboarding(page: .idealSchedule, prefs: UserPrefs()))
            .environmentObject(UserPrefs())
    }
}
