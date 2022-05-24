//
//  Config.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/01/2022.
//

import Foundation
import SwiftUI

class Config: ObservableObject {
    
    @ObservedObject var prefs: UserPrefs
    @ObservedObject var history: History
    @ObservedObject var scheduler: TugScheduler
    @ObservedObject var settings: DeviceSettings
    var navigator: Navigator!
    
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        }
    }
    
    init() {
        
        let prefs = UserPrefs.loadFromStore()
        let history = History.loadFromStore()
        let scheduler = TugScheduler(prefs: prefs, history: history)
        self.prefs = prefs
        self.history = history
        self.scheduler = scheduler
        
        settings = DeviceSettings.load()
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        navigator = Navigator(config: self)
    }
    
    init(forTest: Bool) {
        
        let h = History(tugs: [Tug.testTug()])
        let prefs = UserPrefs(forTest: forTest)
        
        history = h
        scheduler = TugScheduler(prefs: prefs, history: h)
        self.prefs = prefs
        
        settings = DeviceSettings()
        hasSeenOnboarding = true
        navigator = Navigator(config: self)
    }
}
