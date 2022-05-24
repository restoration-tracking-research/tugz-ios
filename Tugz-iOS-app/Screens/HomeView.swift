//
//  ContentView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var config: Config
    
    @State var formattedTimeUntilNextTug: String = ""
    
    var sessionsTodayText: String {
        
        let count = config.scheduler.todaySessionCount
        
        return count > 0 ? "\(count)" : "Ready to start"
    }
    
    @State var navToTugNowActive = false
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var scheduler: TugScheduler { config.scheduler }
    
    var prefs: UserPrefs { config.prefs }
    
    @State private var logoOpacity = 0.0
    
    init(config: Config) {
        
        self.config = config
        
        formattedTimeUntilNextTug = config.scheduler.formattedTimeUntilNextTug()
    }

    var body: some View {
        
        ZStack {
            
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "t.circle.fill")
                .font(.system(size: 500, weight: .heavy))
                .frame(width: 150, height: 150)
                .foregroundColor(.accentColor)
                .position(x: 80, y: 40)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation {
                        logoOpacity = 0.3
                    }
                }
            
            VStack(alignment: .center) {
//                Text("CI-7")
                
                Text("Today's progress:")
                    .font(.largeTitle).bold()
                
                Text(config.scheduler.formattedTotalTugTimeToday())
                    .font(.largeTitle)
                    .padding(.top, -4)
                    .padding(.bottom, 10)
                
                Text(config.scheduler.formattedGoalTimeToday())
                    .font(.title)
                    .padding(.bottom, 22)
                
                Text("Sessions today:")
                    .font(.title)
                
                Text(sessionsTodayText)
                    .font(.largeTitle).bold()
                ProgressCircle(progress: config.scheduler.percentDoneToday)
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
                        Text(config.scheduler.formattedTimeOfNextTug())
                            .bold()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: TugView(config: config, tug: nil, isPresented: $navToTugNowActive),
                                   isActive: $navToTugNowActive) {
                        
                        Button {
                            /// Transition to tug screen
                            self.navToTugNowActive = true
                        } label: {
                            Text("TUG NOW")
                                .font(.system(.headline))
                                .frame(width: 250)

                        }
                        .buttonStyle(FilledButton())
                    }
                }
                Spacer(minLength: 20)
                
            }.progressViewStyle(TugzProgressViewStyle())
        }
        .onReceive(timer) { _ in
            self.formattedTimeUntilNextTug = scheduler.formattedTimeUntilNextTug()
        }
    }
    
//    func tugNowTug() -> Tug {
//        
//        let duration = prefs.tugDuration.converted(to: .seconds).value
//        let tugDelta = prefs.tugInterval.converted(to: .seconds).value / 10
//        let now = Date()
//        
//        if let nextTugTime = scheduler.timeOfNextTug(), nextTugTime.timeIntervalSinceNow.magnitude < tugDelta {
//            
//            return Tug(scheduledFor: nextTugTime, scheduledDuration: duration, start: now, state: .started)
//            
//        } else {
//            
//            return Tug(scheduledFor: nil, scheduledDuration: duration, start: now, state: .started)
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
        
    static let h = History(tugs: [Tug.testTug()])
    
    static var previews: some View {
        
        Group {
            TabView {
                HomeView(config: Config(forTest: true))
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
            }
            TabView {
                HomeView(config: Config(forTest: true))
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
            }
        }
    }
}
