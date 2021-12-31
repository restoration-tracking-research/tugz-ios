//
//  SettingsView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    let prefs: UserPrefs
    
    @State private var firstTugTime = Date()
    @State private var lastTugTime = Date()
    @State private var tugDuration: TimeInterval = 0
    @State private var tugInterval: TimeInterval = 0
    
    init(prefs: UserPrefs = UserPrefs.load()) {
        self.prefs = prefs
    }
    
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
                                prefs.firstTugTime = Calendar.current.dateComponents([.hour, .minute], from: firstTugTime)
                            }
                        
                        DatePicker(
                            "Time of last tug",
                            selection: $lastTugTime,
                            displayedComponents: [.hourAndMinute]
                        )
                            .onChange(of: lastTugTime) { newValue in
                                prefs.lastTugTime = Calendar.current.dateComponents([.hour, .minute], from: lastTugTime)
                            }
                        
                        /// Set tug duration
                        VStack(alignment: .leading) {
                            Text("Tug duration")
                            TimeDurationPicker(duration: $tugDuration)
                                .onChange(of: tugDuration) { newValue in
                                    prefs.tugDuration = Measurement(value: tugDuration, unit: .seconds)
                                }
                        }
                        
                        /// Set time between tugs
                        VStack(alignment: .leading) {
                            Text("Tug every")
                            TimeDurationPicker(duration: $tugInterval)
                                .onChange(of: tugInterval) { newValue in
                                    prefs.tugInterval = Measurement(value: tugInterval, unit: .seconds)
                                }
                        }
                    }
                }
            }
            
        }
        .navigationBarTitle(Text("Settings"))
        .onAppear {
            
            var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
            
            components.hour = prefs.firstTugTime.hour
            components.minute = prefs.firstTugTime.minute
            
            if let first = Calendar.current.date(from: components) {
                firstTugTime = first
            } else {
                print("hi")
            }
            
            components.hour = prefs.lastTugTime.hour
            components.minute = prefs.lastTugTime.minute
            
            if let last = Calendar.current.date(from: components) {
                lastTugTime = last
            } else {
                print("hi")
            }
            tugDuration = prefs.tugDuration.converted(to: .seconds).value
            tugInterval = prefs.tugInterval.converted(to: .seconds).value
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
