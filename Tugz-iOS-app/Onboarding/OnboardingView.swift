//
//  IntroPageViewController.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI
import ConcentricOnboarding

struct OnboardingView: View {
    
    let onboarding = Onboarding()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userPrefs: UserPrefs
    
    var body: some View {
        
        onboarding.view = ConcentricOnboardingView<OnboardingSubview>(pageContents: onboarding.buildViews())
            .insteadOfCyclingToLastPage {}
            .insteadOfCyclingToFirstPage {
                /// No-op
                presentationMode.wrappedValue.dismiss()
            }
//            .didPressNextButton {
//                if onboarding.currentPage == .readyToStart,
//                   userPrefs.usesDevices == false {
//                    onboarding.view.goToNextPage(animated: false)
//                }
//                onboarding.view.goToNextPage()
//            }
            .didChangeCurrentPage { currentPage in
                onboarding.updatePage(currentPage)
            }
        
        return onboarding.view
            .environmentObject(onboarding)
            .environmentObject(userPrefs)
    }
}

struct IntroPageViewController_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
