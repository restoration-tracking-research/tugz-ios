//
//  ContentView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct HomeView: View {
    
    let config: Config
    
    @State var percentDoneToday: Double = 0
    @State var formattedTotalTugTimeToday: String = ""
    @State var formattedTimeUntilNextTug: String = ""
    @State var formattedTimeOfNextTug: String = ""
    @State var sessionsToday: Int = 0
    
    @State var navToTugNowActive = false
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var scheduler: TugScheduler { config.scheduler }
    
    var prefs: UserPrefs { config.prefs }
    
    init(config: Config) {
        self.config = config
        percentDoneToday = config.scheduler.percentDoneToday
        formattedTotalTugTimeToday = config.scheduler.formattedTotalTugTimeToday()
        formattedTimeUntilNextTug = config.scheduler.formattedTimeUntilNextTug()
        formattedTimeOfNextTug = config.scheduler.formattedTimeOfNextTug()
        sessionsToday = config.scheduler.todaySessionCount
        navToTugNowActive = config.navigator.needsToStartTugFromNotification
    }

    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack {
//                Text("CI-7")
                Text("Tugz")
                    .font(.largeTitle)
                Text("Total tug time today:")
                Text(formattedTotalTugTimeToday)
                    .font(.largeTitle).bold()
                    .padding(.bottom, 22)
                Text("Sessions today:")
                Text("\(sessionsToday)")
                    .font(.largeTitle).bold()
                ProgressCircle(progress: $percentDoneToday)
                    .frame(width: 150.0, height: 150.0)
                    .padding(22)
                
                VStack {
                    HStack {
                        Text("Next session in")
                        if #available(iOS 15.0, *) {
                            Text(formattedTimeUntilNextTug)
                                .monospacedDigit()
                                .bold()
                        } else {
                            Text(formattedTimeUntilNextTug)
                                .font(.system(size: 14, design: .monospaced))
                                .bold()
                        }
                        Text("at")
                        Text(formattedTimeOfNextTug)
                            .bold()
                    }
                    NavigationLink(destination: TugView(config: config, tug: nil, isPresented: $navToTugNowActive),
                                   isActive: $navToTugNowActive) {
                        Button("TUG NOW") {
                            /// Transition to tug screen
                            self.navToTugNowActive = true
                        }
                        .buttonStyle(FilledButton())
                    }
                }
                Spacer()
                
            }.progressViewStyle(TugzProgressViewStyle())
        }
        .onReceive(timer) { _ in
            self.percentDoneToday = scheduler.percentDoneToday
            self.formattedTotalTugTimeToday = scheduler.formattedTotalTugTimeToday()
            self.formattedTimeUntilNextTug = scheduler.formattedTimeUntilNextTug()
            self.formattedTimeOfNextTug = scheduler.formattedTimeOfNextTug()
            self.sessionsToday = scheduler.todaySessionCount
        }
    }
    
    func tugNowTug() -> Tug {
        
        let duration = prefs.tugDuration.converted(to: .seconds).value
        let tugDelta = prefs.tugInterval.converted(to: .seconds).value / 10
        let now = Date()
        
        if let nextTugTime = scheduler.timeOfNextTug(), nextTugTime.timeIntervalSinceNow.magnitude < tugDelta {
            
            return Tug(scheduledFor: nextTugTime, scheduledDuration: duration, start: now, state: .started)
            
        } else {
            
            return Tug(scheduledFor: nil, scheduledDuration: duration, start: now, state: .started)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
        
    static let h = History(tugs: [Tug.testTug()])
    
    static var previews: some View {
        
        TabView {
            HomeView(config: Config(forTest: true))
                .tabItem {
                    Label("Home", systemImage: "house")
                }
        }
    }
}
