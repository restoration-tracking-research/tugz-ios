//
//  TugScheduleView.swift
//  Tugz
//
//  Created by Charlie Williams on 21/05/2022.
//

import SwiftUI

struct TugScheduleView: View {
    
    let title: String? // "What's your ideal schedule?"
    let subtitle: String? // "We'll send you notifications to help you meet your goals."
    @ObservedObject var userPrefs: UserPrefs
    
    @State var firstTugTime = Date()
    @State var lastTugTime = Date()
    @State private var tugDuration: TimeInterval
    @State private var tugInterval: TimeInterval
    
    init(title: String? = nil, subtitle: String? = nil, userPrefs: UserPrefs) {
        
        self.title = title
        self.subtitle = subtitle
        self.userPrefs = userPrefs
        
        _tugDuration = State(initialValue: userPrefs.tugDuration.converted(to: .seconds).value)
        _tugInterval = State(initialValue: userPrefs.tugInterval.converted(to: .seconds).value)
        
        _firstTugTime = State(initialValue: userPrefs.firstTugTime.toDateInToday())
        _lastTugTime = State(initialValue: userPrefs.lastTugTime.toDateInToday())
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
                                .fill( userPrefs.daysToTug.contains(day) ? .blue : .gray)
                            
                            Text( day.initial )
                                .font(.system(.headline))
                                .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            if userPrefs.daysToTug.contains(day) {
                                userPrefs.daysToTug = userPrefs.daysToTug.filter { $0 != day }
                            } else {
                                userPrefs.daysToTug.append(day)
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
                        userPrefs.firstTugTime = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                    }
                
                DatePicker("Last Tug of the day", selection: $lastTugTime, displayedComponents: [.hourAndMinute])
                    .listRowSeparator(.hidden)
                    .onChange(of: lastTugTime) { newValue in
                        userPrefs.lastTugTime = Calendar.current.dateComponents([.hour, .minute], from: newValue)
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
                    userPrefs.tugDuration = Measurement(value: newValue, unit: .seconds)
                }
                
                Picker("Tug every", selection: $tugInterval) {
                    ForEach([10, 30, 45, 60, 90, 120], id: \.self) { min in
                        Text("\(min) min").tag(TimeInterval(min * 60))
                    }
                }
                .onChange(of: tugInterval) { newValue in
                    userPrefs.tugInterval = Measurement(value: newValue, unit: .seconds)
                }
                
                Divider()
            }
            .listRowSeparator(.hidden)
            
            Group {
                Toggle("Send manual tug reminders", isOn: $userPrefs.sendManualReminders)
                    .tint(.blue)
                    .onTapGesture {
                        withAnimation {
                            $userPrefs.sendManualReminders.wrappedValue.toggle()
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
                        userPrefs: UserPrefs())
        TugScheduleView(userPrefs: UserPrefs())
    }
}
