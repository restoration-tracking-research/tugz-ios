//
//  Tugz_iOS_appApp.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import UIKit
import SwiftUI

@main
struct TugzApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var config = Config()
    
    var onboarding: some View {
        OnboardingViewPure(onboarding: Onboarding(prefs: config.prefs, onDone: {
            print("done")
            config.hasSeenOnboarding = true
            $presented.wrappedValue = false
        }))
        .environmentObject(config.prefs)
    }
    
    @State var presented = false

    var body: some Scene {
        
        WindowGroup {
            
            TabBarHostingView(config: config)
                .onAppear {
                    
                    appDelegate.app = self
                    
                    let noteSch = NotificationScheduler(settings: config.settings,
                                                        prefs: config.prefs,
                                                        scheduler: config.scheduler)
                    noteSch.request() { granted in
                        if granted {
                            noteSch.scheduleAlerts()
                        }
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                        
                    case .background:
                        config.navigator.appBackgrounded()
                        
                        /// Send debug test notification
                        //                            NotificationScheduler.sendTestNotification()
                        
                    case .inactive:
                        config.navigator.appBackgrounded()
                        
                        /// Send debug test notification
                        //                            NotificationScheduler.sendTestNotification()
                        
                    case .active:
                        History.shared.fetchIfNeeded()
                        
                    @unknown default:
                        fatalError("New thing here")
                    }
                }
                .onOpenURL { url in
                    print(url)
                }
                .sheet(isPresented: $presented) {
                    onboarding
                }
                .onAppear {
                    $presented.wrappedValue = !config.hasSeenOnboarding
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var app: TugzApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        UITableViewHeaderFooterView.appearance().backgroundView = .init()
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        NotificationAction.register()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        app?.config.navigator.appLaunchedFromNotification(response: response)
        completionHandler()
    }
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler(.banner)
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//
////        print(notification)
//        print("hi")
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        print(response)
//    }
    
    
    // The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print(notification ?? "nothing")
    }
}

extension AppDelegate: ObservableObject { }
