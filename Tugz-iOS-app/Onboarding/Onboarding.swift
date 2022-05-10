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
    }
    
    var view: ConcentricOnboardingView<OnboardingSubview>!
    
    private(set) var currentPage = Page.first
    
    var pages: [Page] = [
        .first,
        .aboutRestoration,
        .readyToStart,
        .deviceSelect,
        .idealSchedule,
        .allSet
    ]
    
    var colors: [Color] = [
        .white,
        .white,
        .white,
        .white,
        .white,
        .white
    ]
    
    func buildViews() -> [(OnboardingSubview, Color)] {
        
        pages.indices.map { idx in
            
            let page = pages[idx]
            let color = colors[idx]
            
            return (OnboardingSubview(page: page), color)
        }
    }
    
    func updatePage(_ index: Int) {
        currentPage = Page(rawValue: index)!
    }
}
