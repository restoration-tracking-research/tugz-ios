//
//  TabView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct TabBarHostingView: View {
    
    let scheduler: Scheduler
    
    var body: some View {
        TabView {
            ContentView(scheduler: scheduler)
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
        let scheduler = Scheduler(prefs: UserPrefs(), history: h)
        TabBarHostingView(scheduler: scheduler)
    }
}
