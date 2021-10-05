//
//  ContentView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    let scheduler: Scheduler
    @State var progressValue: Float = 0.28
    
    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("TUGZ")
                    .padding()
                    .font(.largeTitle)
                Text("Total tug time today:")
                Text(scheduler.formattedTotalTugTimeToday())
                    .font(.largeTitle).bold()
                ProgressCircle(progress: self.$progressValue)
                    .frame(width: 150.0, height: 150.0)
                    .padding(40.0)
                
                VStack {
                    HStack {
                        Text("Next session in")
                        Text(scheduler.formattedTimeUntilNextTug())
                            .bold()
                        Text("at")
                        Text(scheduler.formattedTimeOfNextTug())
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let h = History(tugs: [Tug(start: Date(), end: Date())])
        ContentView(scheduler: Scheduler(prefs: UserPrefs(), history: h))
    }
}
