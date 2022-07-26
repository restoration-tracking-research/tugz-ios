//
//  HistoryView.swift
//  Tugz
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
        "\(TimeInterval(tugs.reduce(0) { $0 + $1.duration }).minute) min"
    }
    
    var header: some View {
        HStack {
            Text(tugs.first?.formattedDay ?? "Error")
                .font(.subheadline)
                .foregroundColor(.black)
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
    
    let config: Config
    
    @ObservedObject var history: History
    
    var todayHeader: some View {
        
        Text("Today")
            .font(.system(.title))
            .bold()
    }
    
    var todayFooter: some View {
        HStack {
            Text("⏱ Next tug")
            if config.scheduler.timeOfNextTug()?.isToday == false {
                Text("tomorrow")
                    .bold()
            }
            Text("at")
            Text(config.scheduler.formattedTimeOfNextTug())
                .bold()
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                List {
                    
                    Section(header: todayHeader, footer: todayFooter) {
                        
                        let today = history.tugsToday()
                        if today.isEmpty {
                            Text("Nothing yet today… 🤷‍♂️")
                        } else {
                            ForEach(today) {
                                HistoryRow(tug: $0)
                            }
                        }
                    }
                    .headerProminence(.increased)
                    
                    ForEach(history.tugsByDay(includingToday: false).reversed()) {
                        HistorySection(tugs: $0)
                    }
                    
                }
                .listStyle(.insetGrouped)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text("History"))
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(config: Config(forTest: true), history: Config(forTest: true).history)
    }
}
