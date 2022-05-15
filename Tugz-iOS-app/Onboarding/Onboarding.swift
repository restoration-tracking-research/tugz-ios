//
//  Onboarding.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 10/05/2022.
//

import SwiftUI
import ConcentricOnboarding

class Onboarding: ObservableObject {
    
    enum Page: Int {
        case first
        case aboutRestoration
        case readyToStart
        case deviceSelect
        case idealSchedule
        case allSet
        
        var showsNextButton: Bool {
            return true
            [Page.aboutRestoration, .readyToStart, .deviceSelect, .idealSchedule, .allSet].contains(self)
        }
    }
    
//    var view: ConcentricOnboardingView<OnboardingSubview>!
    var view: OnboardingViewPure!
    
    private(set) var currentPage = Page.first
    
    var pages: [Page] = [
        .first,
        .aboutRestoration,
        .readyToStart,
        .deviceSelect,
        .idealSchedule,
        .allSet
    ]
    
//    var colors: [Color] = [
//        .white,
//        .orange,
//        .white,
//        .orange,
//        .white,
//        .orange
//    ]
//
    func buildViews() -> [OnboardingSubview] {
        
        pages.map { page in
            OnboardingSubview(page: page, onboarding: self)
        }
    }
    
    func updatePage(_ index: Int) {
        currentPage = Page(rawValue: index)!
    }
}
