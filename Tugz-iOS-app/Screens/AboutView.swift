//
//  AboutView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {

                Text("About")
                    .font(.system(.largeTitle))
                    .bold()
                
                Spacer()
                
                /// This app is for restoration tracking
                Text(
                    """
                     This app is for restoration progress tracking.
                     It's currently focused on using manual methods, i.e. many short sessions throughout the day.
                     It can send you reminders and track your tugging durations.
                     No data is sent from your device! This app respects your privacy.
                     We want to add device-based tracking too, please let us know if you're interested in this!
                     This app is funded by supporters like you on [Patreon](https://www.patreon.com/restorationapp).
                    """
                )
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    .lineSpacing(20)
                    .multilineTextAlignment(.leading)
                
                
                Spacer()
//                NavigationLink("View more information on Patreon", destination: URL(string: "https://www.patreon.com/restorationapp")!)

Spacer()

List {
Link("Support our Patreon!", destination: URL(string: "https://www.patreon.com/restorationapp")!)
.font(.title)

Link("Restoration subreddit", destination: URL(string: "https://www.reddit.com/r/foreskin_restoration")!)

Link("Getting started with restoration", destination: URL(string: "https://www.reddit.com/r/foreskin_restoration/comments/g4ghc2/welcome_read_to_get_started_restoring")!)

Link("Help develop this app", destination: URL(string: "https://github.com/restoration-tracking-research/tugz-ios")!)
}

            }
            .padding()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
