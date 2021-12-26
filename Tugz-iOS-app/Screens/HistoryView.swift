//
//  HistoryView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct HistoryRow: View {
    
    var tug: Tug
    
    var body: some View {
        
        HStack {
            Text(tug.formattedStartTime)
            Spacer()
            Text(tug.duration.formatted)
        }
    }
}

struct HistorySection: View {
    
    var tugs: [Tug]
    
    var totalTimeFormatted: String {
        TimeInterval(tugs.reduce(0) { $0 + $1.duration }).formatted
    }
    
    var header: some View {
        HStack {
            Text(tugs.first?.formattedDay ?? "Error")
            Spacer()
            Text(totalTimeFormatted)
        }
    }
    
    var body: some View {
        
        Section(header: header) {
            ForEach(tugs) {
                HistoryRow(tug: $0)
            }
        }
    }
}

struct HistoryView: View {
    
    @EnvironmentObject var prefs: UserPrefs
    @EnvironmentObject var history: History
    @EnvironmentObject var settings: DeviceSettings
    @EnvironmentObject var scheduler: Scheduler
    
    var todayHeader: some View {
        
        Text("Today")
            .font(.system(.largeTitle))
            .bold()
    }
    
    var todayFooter: some View {
        HStack {
            Text("⏱ Next tug")
            if scheduler.timeOfNextTug()?.isToday == false {
                Text("tomorrow")
                    .bold()
            }
            Text("at")
            Text(scheduler.formattedTimeOfNextTug())
                .bold()
        }
    }
    
    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                List {
                    
                    Section(header: todayHeader, footer: todayFooter) {
                        ForEach(history.tugs) {
                            HistoryRow(tug: $0)
                        }
                    }
                    .headerProminence(.increased)
                    
                    ForEach(history.tugsByDay(includingToday: false)) {
                        HistorySection(tugs: $0)
                    }
                    
                }
                .listStyle(.insetGrouped)
                
                Spacer()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
