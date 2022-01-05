//
//  Config.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/01/2022.
//

import Foundation

class Config {
    let prefs: UserPrefs
    let history: History
    let scheduler: TugScheduler
    let settings: DeviceSettings
    var navigator: Navigator!
    
    init() {
        
        prefs = .load()
        history = .load()
        scheduler = TugScheduler(prefs: prefs, history: history)
        settings = DeviceSettings.load()
        navigator = Navigator(config: self)
    }
    
    init(forTest: Bool) {
        
        let h = History(tugs: [Tug.testTug()])
        
        prefs = UserPrefs()
        history = h
        scheduler = TugScheduler(prefs: UserPrefs(), history: h)
        settings = DeviceSettings()
        navigator = Navigator(config: self)
    }
}
