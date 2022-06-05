//
//  TabView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct TabBarHostingView: View {
    
    let config: Config
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            NavigationView {
                HomeView(config: config)
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationView {
                HistoryView(config: config, history: config.history)
            }
            .navigationBarHidden(true)
            .tabItem {
                Label("History", systemImage: "text.book.closed")
            }
            
            NavigationView {
                SettingsView(config: config)
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
        TabBarHostingView(config: Config(forTest: true))
    }
}
