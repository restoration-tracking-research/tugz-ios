//
//  IntroPageViewController.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

struct OnboardingView: View {
    
    var subviews = [
        UIHostingController(rootView: OnboardingSubview(imageName: "LaunchScreen")),
        UIHostingController(rootView: OnboardingSubview(imageName: "AppIcon")),
        UIHostingController(rootView: OnboardingSubview(imageName: "LaunchScreen"))
    ]
    
    var body: some View {
        OnboardingPageViewController(viewControllers: subviews)
            .frame(height: 600)
    }
}

struct IntroPageViewController_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
