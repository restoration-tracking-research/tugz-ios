//
//  TabView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct TabBarHostingView: View {
    
    let scheduler: Scheduler
    let prefs: UserPrefs
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            NavigationView {
                HomeView(scheduler: scheduler, prefs: prefs)
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationView {
                HistoryView()
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("History", systemImage: "text.book.closed")
            }
            
            NavigationView {
                SettingsView()
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            
            NavigationView {
                AboutView()
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("About", systemImage: "info.circle.fill")
            }
        }
    }
}

struct TabBarHostingView_Previews: PreviewProvider {
    static var previews: some View {
        let h = History(tugs: [Tug.testTug()])
        let scheduler = Scheduler(prefs: UserPrefs(), history: h)
        TabBarHostingView(scheduler: scheduler, prefs: UserPrefs())
    }
}
