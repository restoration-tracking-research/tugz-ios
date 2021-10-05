//
//  TabView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct TabBarHostingView: View {
    
    let prefs: UserPrefs
    let history: History
    
    var body: some View {
        TabView {
            ContentView(scheduler: Scheduler(prefs: prefs, history: history))
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Other View")
                .tabItem {
                    Label("Other", systemImage: "arrow.left")
                }
        }
    }
}

struct TabBarHostingView_Previews: PreviewProvider {
    static var previews: some View {
        let h = History(tugs: [Tug(start: Date(), end: Date())])
        TabBarHostingView(prefs: UserPrefs(), history: h)
    }
}
