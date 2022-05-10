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

import ConcentricOnboarding

struct OnboardingSubview: View {
    
    let page: Onboarding.Page
    
    @EnvironmentObject var onboarding: Onboarding
    @EnvironmentObject var userPrefs: UserPrefs
    
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
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.white)
            
            Text("Welcome to Tugz")
                .font(.system(.largeTitle))
                .padding()
            
            Text("What do you know about foreskin restoration?")
                .padding()
            
            
            VStack {
                Button("Not a lot, please fill me in") {
                    onboarding.view.goToNextPage()
                }
                .tint(.indigo)
                .buttonStyle(.borderedProminent)
                .padding()
                .fixedSize(horizontal: true, vertical: false)
                
                Button("I’m ready to start restoring") {
                    onboarding.view.goToNextPage(animated: false)
                    onboarding.view.goToNextPage()
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("I’m restoring already") {
                    onboarding.view.goToNextPage(animated: false)
                    onboarding.view.goToNextPage()
                }
                //            .tint(.orange)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 88, trailing: 0))
        }
    }
    
    var aboutRestoration: some View {
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
            Text("5 things to know about foreskin restoration")
                .font(.system(.largeTitle))
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            
            VStack(alignment: .leading, spacing: 36) {
                HStack {
                    Image(systemName: "crown")
                    Text("It’s been practiced for thousands of years")
                }
                
                HStack {
                    Image(systemName: "bandage")
                    Text("It uses similar tissue expansion techniques that doctors use in a medical setting")
                }
                
                HStack {
                    Image(systemName: "calendar.badge.clock")
                    Text("It works, but it’s a slow process. Patience and persistence pay off!")
                }
                
                HStack {
                    Image(systemName: "hands.sparkles.fill")
                    Text("You don’t need any special equipment to get started")
                }
                
                HStack {
                    Image(systemName: "person.3.sequence.fill")
                    Text("There are thriving online communities, with lots of resources and further reading. Look them up and keep learning!")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 180, trailing: 20))
        }
    }
    
    var readyToStart: some View {
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.white)
            
            Text("Ready to start?")
                .font(.system(.largeTitle))
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            
            Text("Just a couple of questions to get started:")
                .padding()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Toggle("Do you use manual methods?", isOn: $userPrefs.usesManual)
                        .toggleStyle(.automatic)
                        .font(.system(.headline))
                }
                Text("If so, Tugz can send you regular reminders throughout the day so you can get all your sessions in.")
                    .padding()
                
                HStack {
                    Toggle("Do you use any devices?", isOn: $userPrefs.usesDevices)
                        .toggleStyle(.automatic)
                        .font(.system(.headline))
                }
                Text("If so, we'll let you pick them list of commercially-available devices.")
                Text("When you start a session, we’ll just show you the devices you actually have instead of this whole list every time.")
                Text("(If you get more devices in the future, you can add them in later)")
            }
            .padding()
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 120, trailing: 20))
    }
    
    var deviceSelect: some View {
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
            List {
                DeviceCategory.allCases.map {
                    Text($0.displayName)
                }
            }
        }
    }
    
    var idealSchedule: some View {
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
        }
    }
    
    var allSet: some View {
        
        VStack {
            Image(systemName: "t.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.white)
            
        }
    }
}

struct OnboardingSubview_Previews: PreviewProvider {
    
    static let onboarding = Onboarding()
    static let userPrefs = UserPrefs.loadFromStore()
    
    static var previews: some View {
        OnboardingSubview(page: .first)
            .environmentObject(onboarding)
            .environmentObject(userPrefs)
//        OnboardingSubview(page: .aboutRestoration)
//            .environmentObject(onboarding)
//            .environmentObject(userPrefs)
        OnboardingSubview(page: .readyToStart)
            .environmentObject(onboarding)
            .environmentObject(userPrefs)
//        OnboardingSubview(page: .idealSchedule)
//            .environmentObject(onboarding)
//            .environmentObject(userPrefs)
//        OnboardingSubview(page: .allSet)
//            .environmentObject(onboarding)
//            .environmentObject(userPrefs)
    }
}
