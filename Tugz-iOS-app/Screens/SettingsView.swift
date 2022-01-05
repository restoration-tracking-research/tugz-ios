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
            
            VStack(alignment: .leading) {
                
                List {
                    
                    Section {
                        
                        /// Set start/stop times
                        DatePicker(
                            "Time of first tug",
                            selection: $firstTugTime,
                            displayedComponents: [.hourAndMinute]
                        )
                            .onChange(of: firstTugTime) { newValue in
                                config.prefs.firstTugTime = Calendar.current.dateComponents([.hour, .minute], from: firstTugTime)
                            }
                        
                        DatePicker(
                            "Time of last tug",
                            selection: $lastTugTime,
                            displayedComponents: [.hourAndMinute]
                        )
                            .onChange(of: lastTugTime) { newValue in
                                config.prefs.lastTugTime = Calendar.current.dateComponents([.hour, .minute], from: lastTugTime)
                            }
                        
                        /// Set tug duration
                        VStack(alignment: .leading) {
                            Text("Tug duration")
                            TimeDurationPicker(duration: $tugDuration)
                                .onChange(of: tugDuration) { newValue in
                                    config.prefs.tugDuration = Measurement(value: tugDuration, unit: .seconds)
                                }
                        }
                        
                        /// Set time between tugs
                        VStack(alignment: .leading) {
                            Text("Tug every")
                            TimeDurationPicker(duration: $tugInterval)
                                .onChange(of: tugInterval) { newValue in
                                    config.prefs.tugInterval = Measurement(value: tugInterval, unit: .seconds)
                                }
                        }
                    }
                }
            }
            
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
