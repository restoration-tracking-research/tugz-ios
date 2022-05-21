//
//  Onboarding.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 10/05/2022.
//

import SwiftUI
import AVFAudio

class Onboarding: ObservableObject {
    
    enum Page: Int {
        case first
        case aboutRestoration
        case readyToStart
        case deviceSelect
        case idealSchedule
        case allSet
        
        var showsNextButton: Bool {
            [Page.aboutRestoration, .readyToStart, .deviceSelect, .idealSchedule, .allSet].contains(self)
        }
    }
    
    var view: OnboardingViewPure!
    
    @Published private(set) var currentPage: Page
    
    var pages: [Page] = [
        .first,
        .aboutRestoration,
        .readyToStart,
        .deviceSelect,
        .idealSchedule,
        .allSet
    ]
    
    init(page: Page = .first) {
        self.currentPage = page
    }
    
    func buildViews() -> [OnboardingSubview] {
        
        pages.map { page in
            OnboardingSubview(page: page, onboarding: self)
        }
    }
    
    func updatePage(_ index: Int) {
        currentPage = Page(rawValue: index)!
    }
}
