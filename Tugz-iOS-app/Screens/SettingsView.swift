//
//  SettingsView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    let config: Config
    
    @State private var firstTugTime = Date()
    @State private var lastTugTime = Date()
    @State private var tugDuration: TimeInterval = 0
    @State private var tugInterval: TimeInterval = 0
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            TugScheduleView(userPrefs: config.prefs)            
        }
        .navigationBarTitle(Text("Settings"))
        .onAppear {
            
            var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
            
            components.hour = config.prefs.firstTugTime.hour
            components.minute = config.prefs.firstTugTime.minute
            
            if let first = Calendar.current.date(from: components) {
                firstTugTime = first
            } else {
                print("hi")
            }
            
            components.hour = config.prefs.lastTugTime.hour
            components.minute = config.prefs.lastTugTime.minute
            
            if let last = Calendar.current.date(from: components) {
                lastTugTime = last
            } else {
                print("hi")
            }
            tugDuration = config.prefs.tugDuration.converted(to: .seconds).value
            tugInterval = config.prefs.tugInterval.converted(to: .seconds).value
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(config: Config(forTest: true))
    }
}
