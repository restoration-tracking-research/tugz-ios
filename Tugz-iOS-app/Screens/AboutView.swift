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
            VStack {
                Text("TUGZ")
                    .font(.largeTitle)
                Text("A community restoration tracking app")
                Spacer()
                
                List {
                    Link("Support our Patreon!", destination: URL(string: "https://www.patreon.com/restorationapp")!)
                        .font(.title)
                    
                    Link("Restoration subreddit", destination: URL(string: "https://www.reddit.com/r/foreskin_restoration")!)
                                        
                    Link("Getting started with restoration", destination: URL(string: "https://www.reddit.com/r/foreskin_restoration/comments/g4ghc2/welcome_read_to_get_started_restoring")!)
                    
                    Link("Help develop this app", destination: URL(string: "https://github.com/restoration-tracking-research/tugz-ios")!)
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
