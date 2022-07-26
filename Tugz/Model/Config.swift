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
        willSet {
            UserDefaults.standard.set(newValue, forKey: "hasSeenOnboarding")
        }
    }
    
    init() {
        
        let prefs = UserPrefs.loadFromStore()
        let history = History.shared
        let scheduler = TugScheduler(prefs: prefs, history: history)
        self.prefs = prefs
        self.history = history
        self.scheduler = scheduler
        
        settings = DeviceSettings.load()
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        navigator = Navigator(config: self)
    }
    
    init(forTest: Bool) {
        
        let h = History(forTest: true)
        let prefs = UserPrefs(forTest: forTest)
        
        history = h
        scheduler = TugScheduler(prefs: prefs, history: h)
        self.prefs = prefs
        
        settings = DeviceSettings()
        hasSeenOnboarding = true
        navigator = Navigator(config: self)
    }
}
