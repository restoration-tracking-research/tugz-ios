//
//  TugScheduleView.swift
//  Tugz
//
//  Created by Charlie Williams on 21/05/2022.
//

import SwiftUI

struct TugScheduleView: View {

    @EnvironmentObject var prefs: UserPrefs
    
    let title: String? // "What's your ideal schedule?"
    let subtitle: String? // "We'll send you notifications to help you meet your goals."
    
    @State var firstTugTime = Date()
    @State var lastTugTime = Date()
    @State private var tugDuration: TimeInterval
    @State private var tugInterval: TimeInterval
    
    init(title: String? = nil, subtitle: String? = nil, prefs: UserPrefs) {
        
        self.title = title
        self.subtitle = subtitle
        
        _tugDuration = State(initialValue: prefs.tugDuration.converted(to: .seconds).value)
        _tugInterval = State(initialValue: prefs.tugInterval.converted(to: .seconds).value)
        
        _firstTugTime = State(initialValue: prefs.firstTugTime.toDateInToday())
        _lastTugTime = State(initialValue: prefs.lastTugTime.toDateInToday())
    }
    
    var body: some View {
        
        Form {
            
            Group {
                
                if let title = title {
                    Text(title)
                        .font(.system(.largeTitle))
                }
                
                if let subtitle = subtitle {
                    
                    Text(subtitle)
                        .font(.system(.footnote))
                        .listRowSeparator(.hidden)
                    
                    Divider()
                }
            }
            
            
            Group {
                Text("Tug Days")
                    .font(.system(.headline))
                    .listRowSeparator(.hidden)
                
                HStack {
                    
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        
                        ZStack {
                            
                            Circle()
                                .fill( prefs.daysToTug.contains(day) ? .blue : .gray)
                            
                            Text( day.initial )
                                .font(.system(.headline))
                                .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            if prefs.daysToTug.contains(day) {
                                prefs.daysToTug = prefs.daysToTug.filter { $0 != day }
                            } else {
                                prefs.daysToTug.append(day)
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Divider()
            }
            
            Group {
                
                DatePicker("First Tug of the day", selection: $firstTugTime, displayedComponents: [.hourAndMinute])
                    .onChange(of: firstTugTime) { newValue in
                        prefs.firstTugTime = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                    }
                
                DatePicker("Last Tug of the day", selection: $lastTugTime, displayedComponents: [.hourAndMinute])
                    .listRowSeparator(.hidden)
                    .onChange(of: lastTugTime) { newValue in
                        prefs.lastTugTime = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                    }
                
                Divider()
            }
            .listRowSeparator(.hidden)
            
            Group {
                
                Picker("Tug duration", selection: $tugDuration) {
                    ForEach(1..<20, id: \.self) { min in
                        Text("\(min) min").tag(TimeInterval(min * 60))
                    }
                }
                .tag("5")
                .onChange(of: tugDuration) { newValue in
                    prefs.tugDuration = Measurement(value: newValue, unit: .seconds)
                }
                
                Picker("Tug every", selection: $tugInterval) {
                    ForEach([10, 30, 45, 60, 90, 120], id: \.self) { min in
                        Text("\(min) min").tag(TimeInterval(min * 60))
                    }
                }
                .onChange(of: tugInterval) { newValue in
                    prefs.tugInterval = Measurement(value: newValue, unit: .seconds)
                }
                
                Divider()
            }
            .listRowSeparator(.hidden)
            
            Group {
                Toggle("Send manual tug reminders", isOn: $prefs.sendManualReminders)
                    .tint(.blue)
                    .onTapGesture {
                        withAnimation {
                            $prefs.sendManualReminders.wrappedValue.toggle()
                        }
                    }
                    .listRowSeparator(.hidden)
                
                Text("Turn this off if you only use devices, or if you want to track your tug time but not get reminders to tug.")
                    .font(.system(.footnote))
            }
        }
    }
}

struct TugScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        TugScheduleView(title: "What's your ideal schedule?",
                        subtitle: "We'll send you notifications to help you meet your goals.",
                        prefs: UserPrefs())
        .environmentObject(UserPrefs())
        TugScheduleView(prefs: UserPrefs())
            .environmentObject(UserPrefs())
    }
}
