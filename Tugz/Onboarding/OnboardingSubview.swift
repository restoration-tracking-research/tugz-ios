//
//  OnboardingSubview.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

/*
 1. Do you know about foreskin restoration?
     - [ ] Yes, I’m restoring already / Yes, I’m ready to start
     - [ ] No, what’s this all about?

 2. No: 5 things to know about foreskin restoration
     - [ ] It’s been practiced for thousands of years
     - [ ] It uses similar tissue expansion techniques that doctors use in a medical setting
     - [ ] It works, but it’s a slow process. Patience and persistence pay off!
     - [ ] You don’t need any special equipment to get started
     - [ ] There are thriving online communities and resources. Look them up and keep learning!
     - [ ] Option: I’d like to get started

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
    
    @State private var logoOpacity = 0.0
    
    var body: some View {
        
        switch page {
        case .first:
            return AnyView(first)
        case .aboutRestoration:
            return AnyView(aboutRestoration)
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
    
    var first: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "t.circle.fill")
                .font(.system(size: 500, weight: .heavy))
                .frame(width: 150, height: 150)
                .foregroundColor(.accentColor)
                .position(x: 80, y: 140)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation {
                        logoOpacity = 0.3
                    }
                }
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                Text("Welcome to Tugz")
                    .font(.system(.largeTitle))
                    .bold()
                    .padding(.leading, 30)
                
                Text("👋 So far, what do you already know about foreskin restoration?")
                    .padding(EdgeInsets(top: 44, leading: 30, bottom: 20, trailing: 0))
                
                VStack {
                    
                    Button {
                        onboarding.updatePage(1)
                    } label: {
                        Text("👌 Not a lot, please fill me in")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .tint(.black)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    
                    Button {
                        onboarding.updatePage(2)
                    } label: {
                        Text("🤗 I’m ready to start restoring")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .tint(.black)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    
                    Button {
                        onboarding.updatePage(2)
                    } label: {
                        Text("👊 I’m restoring already")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .tint(.black)
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                }
                
                .padding(.bottom, 50)
            }
        }
    }
    
    let iconSize: CGFloat = 20
    
    var aboutRestoration: some View {
        
        ZStack {
            
            Rectangle()
                .background(Color.accentColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "t.circle.fill")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.white)
                
                Text("5 things to know about foreskin restoration")
                    .font(.system(.largeTitle))
                    .bold()
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 20))
                
                Divider()
                    .frame(height: 44)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "crown")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.white)
                        Text("It’s been practiced for thousands of years")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "bandage")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.white)
                        Text("It uses similar tissue expansion techniques that doctors use in a medical setting")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.white)
                        Text("It works, but it’s a slow process. Patience and persistence pay off!")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "hands.sparkles.fill")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.white)
                        Text("You don’t need any special equipment to get started")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "person.3.sequence.fill")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.white)
                        Text("There are thriving online communities, with lots of resources and further reading. Look them up and keep learning!")
                            .foregroundColor(.white)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 150, trailing: 20))
            }
        }
    }
    
    var readyToStart: some View {
        
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
                        .tint(.black)
                }
                Text("If so, Tugz can send you regular reminders throughout the day so you can get all your sessions in.")
                    .font(.system(.caption))

                Divider()
                
                HStack {
                    Toggle("Do you use any devices?", isOn: $userPrefs.usesDevices)
                        .toggleStyle(.automatic)
                        .font(.system(.headline))
                        .tint(.black)
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

                    Text("Select the devices you own")
                        .font(.system(.largeTitle))
                        .bold()
                        .listRowSeparator(.hidden)

                    Text("If you get more devices in the future, you can add them later.")
                        .font(.system(.body))
                    
                    DeviceListView()
                        .environmentObject(userPrefs)
            }
                .padding()
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
    
    static let onboarding = Onboarding(prefs: UserPrefs.loadFromStore())
    static let userPrefs = UserPrefs.loadFromStore()
    static let selectedDevices: [Device] = [.DTR, .Foreskinned_Gravity, .Foreskinned_Air]
    
    static var previews: some View {
        OnboardingSubview(page: .first, onboarding: onboarding)
            .environmentObject(userPrefs)
        OnboardingSubview(page: .aboutRestoration, onboarding: onboarding)
            .environmentObject(userPrefs)
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
