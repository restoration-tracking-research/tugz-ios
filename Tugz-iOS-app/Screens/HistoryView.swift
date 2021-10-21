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
    
    var body: some View {
        
        Section(header: Text(tugs.first?.formattedDay ?? "Error")) {
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
    
    var todayFooter: some View {
        HStack {
            Text("Next tug")
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
        List {
            
            Section(header: Text("Today"), footer: todayFooter) {
                ForEach(history.tugs) {
                    HistoryRow(tug: $0)
                }
            }
//            .headerProminence(.increased)
            
            ForEach(history.tugsByDay(includingToday: false)) {
                HistorySection(tugs: $0)
            }
            Section(header: Text("Earlier")) {
                ForEach(history.tugs) {
                    Text($0.formattedStartTime)
                }
            }
            
        }
        .listStyle(.insetGrouped)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
