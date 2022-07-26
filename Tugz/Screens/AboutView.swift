//
//  AboutView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct HowToUseView: View {
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                Text("1. Set your preferred start/stop times on the Settings tab.")
                    .padding()
                
                Text("2. Set how often you want the app to remind you. The app will automatically schedule notifications between your start and stop times.")
                    .padding()
                
                Text("3. Tapping a tug notification on your phone's lock screen will automatically start a session recording.")
                    .padding()
                
                Text("4. You can also manually start a session at any time.")
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct PrivacyView: View {
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                Text("No data is sent from your device! This app respects your privacy.")
                    .padding()
                
                Text("Please note that because of this, deleting the app will delete your recorded history.")
                    .font(.footnote)
                    .padding()
                
                Text("In a near future update, we will add the ability to save your history securely and anonymously to the cloud.")
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct AboutView: View {
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                
                List {
                    
                    Section {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("This app is for restoration session and progress tracking.")
                            Text("It can send you reminders and track your tugging durations both manually and with a device.")
                            Text("This app is for the restoring community— Please let us know what you'd like to see added next!")
                        }
                        .font(.footnote)
                        
                        NavigationLink {
                            HowToUseView()
                        } label: {
                            Text("How to use")
                        }
                        
                        NavigationLink {
                            PrivacyView()
                        } label: {
                            Text("Privacy")
                        }
                        .navigationBarTitle(Text("Privacy"))

                        Link(destination: URL(string: "https://www.patreon.com/restorationapp")!) {
                            HStack {
                                Text("Support our Patreon!")
                                Spacer()
                                Text("🌐")
                            }
                        }
                        
                        Link(destination: URL(string: "https://github.com/restoration-tracking-research/tugz-ios")!) {
                            HStack {
                                Text("Help develop this app")
                                Spacer()
                                Text("🌐")
                            }
                        }
                        
                        Link(destination: URL(string: "https://www.reddit.com/r/foreskin_restoration")!) {
                            HStack {
                                Text("Restoration group on reddit")
                                Spacer()
                                Text("🌐")
                            }
                        }
                        
                        Link(destination: URL(string: "https://www.reddit.com/r/foreskin_restoration/comments/g4ghc2/welcome_read_to_get_started_restoring")!) {
                            HStack {
                                Text("Restoration resources")
                                Spacer()
                                Text("🌐")
                            }
                        }
                    }
                    .headerProminence(.increased)
                    .navigationBarTitle(Text("About"))
                }
                
                Spacer()
                
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
