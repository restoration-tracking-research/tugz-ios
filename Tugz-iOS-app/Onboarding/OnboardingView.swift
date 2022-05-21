//
//  IntroPageViewController.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

struct OnboardingViewPure: View {
    
    @ObservedObject var onboarding: Onboarding

    var doneFunction: () -> ()
    
    @State var slideGesture: CGSize = CGSize.zero

    var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    init(onboarding: Onboarding, doneFunction: @escaping (() -> ())) {
        
        self.onboarding = onboarding
        self.doneFunction = doneFunction
        onboarding.view = self
    }
    
    func goToNextPage() {
        if onboarding.currentPage.rawValue == onboarding.pages.count - 1 {
            doneFunction()
            return
        }
        
        if onboarding.currentPage.rawValue < onboarding.pages.count - 1 {
            withAnimation {
                onboarding.updatePage(onboarding.currentPage.rawValue + 1)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .center) {
                ForEach(onboarding.pages, id: \.self) { page in
                    OnboardingSubview(page: page, onboarding: onboarding)
                        .offset(x: CGFloat(onboarding.currentPage.rawValue) * screenWidth)
                        .offset(x: slideGesture.width - CGFloat(onboarding.currentPage.rawValue) * screenWidth)
                        .animation(.spring(), value: slideGesture)
                        .gesture(DragGesture().onChanged{ value in
                            slideGesture = value.translation
                        }
                        .onEnded { value in
                            if slideGesture.width < -50 {
                                if onboarding.currentPage.rawValue < onboarding.pages.count - 1 {
                                    withAnimation {
                                        onboarding.updatePage(onboarding.currentPage.rawValue + 1)
                                    }
                                }
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
            
            
            VStack {
                Spacer()
                HStack {
                    progressView()
                    Spacer()
                    
                    if onboarding.currentPage.showsNextButton {
                        Button(action: goToNextPage) {
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
        OnboardingViewPure(onboarding: Onboarding(), doneFunction: { print("done") })
    }
}
