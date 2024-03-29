//
//  ContentView.swift
//  Tugz
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var config: Config {
        didSet {
            scheduler = config.scheduler
        }
    }
    @ObservedObject var scheduler: TugScheduler
    @ObservedObject var prefs: UserPrefs
    
    @State var formattedTimeUntilNextTug: String = ""
    @State var navToTugNowActive = false
    @State private var logoOpacity = 0.0
    
    var sessionsTodayText: String {
        
        let count = scheduler.todaySessionCount
        let goal = scheduler.prefs.allDailyTugTimes().count
        
        return count > 0 ? "\(count) of \(goal) sessions" : "Ready to start"
    }
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    init(config: Config) {
        
        self.config = config
        self.scheduler = config.scheduler
        self.prefs = config.prefs
        
        formattedTimeUntilNextTug = scheduler.formattedTimeUntilNextTug()
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
                Spacer(minLength: 80)
                
                Text("Today's progress:")
                    .font(.largeTitle).bold()
                
                Text("\(scheduler.formattedTotalTugTimeToday()) / \(sessionsTodayText)")
                    .font(.largeTitle).bold()
                    .padding(.top, -4)
                    .padding(.bottom, 10)
                
                Text(scheduler.formattedProgressString())
                    .font(.title)
                    .padding(.bottom, 22)
    
                ProgressCircle(progress: scheduler.percentDoneToday)
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
                        Text(scheduler.formattedTimeOfNextTug())
                            .bold()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination:
                                    LazyView(TugView(config: config, isPresented: $navToTugNowActive)),
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
}

struct ContentView_Previews: PreviewProvider {
        
    static let h = History(forTest: true)
    
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
