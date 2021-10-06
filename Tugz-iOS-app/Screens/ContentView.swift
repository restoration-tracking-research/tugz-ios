//
//  ContentView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    let scheduler: Scheduler
    @State var percentDoneToday: Double
    @State var formattedTotalTugTimeToday: String
    @State var formattedTimeUntilNextTug: String
    @State var formattedTimeOfNextTug: String
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    init(scheduler: Scheduler) {
        self.scheduler = scheduler
        percentDoneToday = scheduler.percentDoneToday
        formattedTotalTugTimeToday = scheduler.formattedTotalTugTimeToday()
        formattedTimeUntilNextTug = scheduler.formattedTimeUntilNextTug()
        formattedTimeOfNextTug = scheduler.formattedTimeOfNextTug()
    }

    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("CI-0")
                    .padding()
                    .font(.largeTitle)
                Text("Total tug time today:")
                Text(formattedTotalTugTimeToday)
                    .font(.largeTitle).bold()
                ProgressCircle(progress: $percentDoneToday)
                    .frame(width: 150.0, height: 150.0)
                    .padding(40.0)
                
                VStack {
                    HStack {
                        Text("Next session in")
                        Text(formattedTimeUntilNextTug)
                            .bold()
                        Text("at")
                        Text(formattedTimeOfNextTug)
                            .bold()
                    }
                    Button("TUG NOW") {
                        /// Transition to tug screen
                    }
                    .buttonStyle(FilledButton())
                }
                Spacer()
                
            }.progressViewStyle(TugzProgressViewStyle())
        }
        .onReceive(timer) { _ in
            self.percentDoneToday = scheduler.percentDoneToday
            self.formattedTotalTugTimeToday = scheduler.formattedTotalTugTimeToday()
            self.formattedTimeUntilNextTug = scheduler.formattedTimeUntilNextTug()
            self.formattedTimeOfNextTug = scheduler.formattedTimeOfNextTug()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let h = History(tugs: [Tug(start: Date(), end: Date())])
        ContentView(scheduler: Scheduler(prefs: UserPrefs(), history: h))
    }
}
