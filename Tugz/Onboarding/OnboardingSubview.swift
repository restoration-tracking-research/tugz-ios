//
//  OnboardingSubview.swift
//  Tugz
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

/*

 2. Yes:
     - [ ] Do you use manual methods? If so, Tugz can send you regular reminders throughout the day so you can get all your sessions in.
     - [ ] Do you use devices?
         - [ ] List of devices – which ones do you own or plan to have soon? When you go to tug we’ll just show you the devices you actually have instead of this whole list every time. (If you get more devices in the future, you can add them in later)
         - [ ]

 3. What’s your ideal schedule?
     - [ ] First tug of the day
     - [ ] Last tug of the day
     - [ ] Tug duration
     - [ ] Send a reminder to put on a device at:
         - [ ] X time
         - [ ] Add another

 4. Ok, you’re all set! We’ll send your first reminder at X:XX.
 6. Any time you want to tug you can also start a manual or device session right here in the app. Keep on tugging!
 */

struct OnboardingSubview: View {
    
    let page: Onboarding.Page
    let onboarding: Onboarding
    
    @EnvironmentObject var userPrefs: UserPrefs
    @EnvironmentObject var config: Config
    
    @Environment(\.dismiss) var dismiss
    
    @State private var logoOpacity = 0.0
    
    var body: some View {
        
        switch page {
        case .readyToStart:
            return AnyView(readyToStart)
        case .deviceSelect:
            return AnyView(deviceSelect)
        case .idealSchedule:
            return AnyView(idealSchedule)
        case .allSet:
            return AnyView(allSet)
        }
    }
    
    let iconSize: CGFloat = 20
    
    var readyToStart: some View {
        
        ZStack(alignment: .topTrailing) {
            VStack {
                Image(systemName: "t.circle.fill")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.accentColor)
                
                Text("Ready to start?")
                    .font(.system(.largeTitle))
                    .bold()
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                
                Text("Just a couple of questions to get started:")
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Toggle("Do you use manual methods?", isOn: $userPrefs.usesManual)
                            .toggleStyle(.automatic)
                            .font(.system(.headline))
//                            .tint(.green)
                    }
                    Text("If so, Tugz can send you regular reminders throughout the day so you can get all your sessions in.")
                        .font(.system(.caption))
                    
                    Divider()
                    
                    HStack {
                        Toggle("Do you use any devices?", isOn: $userPrefs.usesDevices)
                            .toggleStyle(.automatic)
                            .font(.system(.headline))
//                            .tint(.green)
                    }
                    Text("If so, we'll let you pick them list of commercially-available devices.")
                        .font(.system(.caption))
                    Text("When you start a session, we’ll just show you the devices you actually have instead of this whole list every time.")
                        .font(.system(.caption))
                    Text("(If you get more devices in the future, you can add them in later)")
                        .font(.system(.caption))
                }
                .padding()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 120, trailing: 20))
            
            Button {
                config.hasSeenOnboarding = true
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.gray)
            }
            .padding(15)
            .offset(CGSize(width: 0, height: -55))
        }
    }
    
    var deviceSelect: some View {
        
        ZStack {
            
            Rectangle()
                .fill(.white)
                .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        Spacer()
                        Image(systemName: "t.circle.fill")
                            .font(.system(size: 64, weight: .heavy))
                            .foregroundColor(.orange)
                        Spacer()
                    }

                    Text("Select any devices you use")
                        .font(.system(.largeTitle))
                        .bold()
                        .listRowSeparator(.hidden)

                    Text("If you get more devices in the future, you can add them later.")
                        .font(.system(.body))
                    
                    DeviceListView()
                        .environmentObject(userPrefs)
                        .edgesIgnoringSafeArea(.horizontal)
            }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 55, trailing: 20))
        }
    }
    
    var idealSchedule: some View {
        
        NavigationView {
            VStack {

                Image(systemName: "t.circle.fill")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.orange)
                    .padding()
                
                TugScheduleView(title: "What's your ideal schedule?",
                                subtitle: "We'll send you notifications to help you meet your goals.",
                                userPrefs: userPrefs)
                
                Spacer(minLength: 55)
            }
        }
        .navigationBarHidden(true)
    }
    
    var displayFirstTugString: String {
        
        if $userPrefs.sendManualReminders.wrappedValue,
            let hour = $userPrefs.firstTugTime.hour.wrappedValue,
            let minute = $userPrefs.firstTugTime.minute.wrappedValue {
            
            let minuteString = String(minute).padding(toLength: 2, withPad: "0", startingAt: 0)
            return "We’ll send your first reminder at \(hour):\(minuteString)."
        } else {
            return ""
        }
    }
    
    var allSet: some View {
        
        ZStack {
            
            Rectangle()
                .background(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                Image(systemName: "t.circle.fill")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 44) {
                    
                    Text("Ok, you’re all set!")
                        .font(.system(.largeTitle))
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(displayFirstTugString)
                        .foregroundColor(.white)
                    
                    Text("Any time you want to tug you can also start a manual or device session right here in the app.")
                        .foregroundColor(.white)
                    
                    Text("Keep on tugging! 👌")
                        .font(.system(.title2))
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct OnboardingSubview_Previews: PreviewProvider {
    
    static let onboarding = Onboarding(config: Config(forTest: true))
    static let userPrefs = UserPrefs.loadFromStore()
    static let selectedDevices: [Device] = [.DTR, .Foreskinned_Gravity, .Foreskinned_Air]
    
    static var previews: some View {
//        OnboardingSubview(page: .first, onboarding: onboarding)
//            .environmentObject(userPrefs)
//        OnboardingSubview(page: .aboutRestoration, onboarding: onboarding)
//            .environmentObject(userPrefs)
        OnboardingSubview(page: .readyToStart, onboarding: onboarding)
            .environmentObject(userPrefs)
        OnboardingSubview(page: .deviceSelect, onboarding: onboarding)
            .environmentObject(userPrefs)
        OnboardingSubview(page: .idealSchedule, onboarding: onboarding)
            .environmentObject(userPrefs)
        OnboardingSubview(page: .allSet, onboarding: onboarding)
            .environmentObject(userPrefs)
    }
}
