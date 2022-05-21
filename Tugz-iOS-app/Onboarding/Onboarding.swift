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
    let prefs: UserPrefs
    
    @Published private(set) var currentPage: Page
    
    var pages: [Page] = [
        .first,
        .aboutRestoration,
        .readyToStart,
        .deviceSelect,
        .idealSchedule,
        .allSet
    ]
    
    var currentPageGradientOpacity: CGFloat {
        switch currentPage {
        case .first,
                .aboutRestoration,
                .readyToStart:
            return 0
        case .deviceSelect:
            return 1
        case .idealSchedule:
            return 1
        case .allSet:
            return 0
        }
    }
    
    var onDone: () -> ()
    
    init(page: Page = .first, prefs: UserPrefs, onDone: @escaping ()->() = {}) {
        
        self.currentPage = page
        self.prefs = prefs
        self.onDone = onDone
    }
    
    func buildViews() -> [OnboardingSubview] {
        
        pages.map { page in
            OnboardingSubview(page: page, onboarding: self)
        }
    }
    
    func updatePage(_ index: Int) {
        currentPage = Page(rawValue: index)!
    }
    
    func goToNextPage() {
        
        guard currentPage.rawValue < pages.count - 1 else {
            onDone()
            view.presentationMode.wrappedValue.dismiss()
            return
        }
        
        let increment: Int
        
        switch currentPage {
        case .first:
            increment = 0
        case .aboutRestoration:
            increment = 1
        case .readyToStart:
            increment = prefs.usesDevices ? 1 : 2
        case .deviceSelect:
            increment = 1
        case .idealSchedule:
            increment = 1
        case .allSet:
            increment = 1
        }
        
        withAnimation {
            updatePage(currentPage.rawValue + increment)
        }
    }
}
