//
//  Tugz_iOS_appApp.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

@main
struct Tugz_iOS_appApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            
            let prefs = UserPrefs.load()
            let history = History.load()
            let settings = DeviceSettings.load()
            let scheduler = Scheduler(prefs: prefs, history: history)
            
            TabBarHostingView(scheduler: scheduler)
                .onAppear {
                    let noteSch = NotificationScheduler(settings: settings, prefs: prefs, scheduler: scheduler)
                    noteSch.request() { granted in
                        if granted {
                            noteSch.scheduleAlerts()
                        }
                    }
                }
        }
    }
}
