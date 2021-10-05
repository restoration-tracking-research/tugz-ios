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
            
            TabBarHostingView(prefs: prefs, history: history)
        }
    }
}
