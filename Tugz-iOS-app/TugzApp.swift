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
    
    init() {
        
    }

    var body: some Scene {
        
        WindowGroup {
            
            let prefs = UserPrefs.load()
            let history = History.load()
            let settings = DeviceSettings.load()
            let scheduler = TugScheduler(prefs: prefs, history: history)
            
            TabBarHostingView(scheduler: scheduler, prefs: prefs)
                .environmentObject(prefs)
                .environmentObject(history)
                .environmentObject(settings)
                .environmentObject(scheduler)
                .onAppear {

                    let noteSch = NotificationScheduler(settings: settings, prefs: prefs, scheduler: scheduler)
                    noteSch.request() { granted in
                        if granted {
                            noteSch.scheduleAlerts()
                        }
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                        
                    case .background:
                        Navigator.shared.appBackgrounded()
                        
                        /// Send debug test notification
                        NotificationScheduler.sendTestNotification()
                        
                    case .inactive:
                        Navigator.shared.appBackgrounded()
                        
                        /// Send debug test notification
                        NotificationScheduler.sendTestNotification()
                        
                    case .active:
                        break
                        
                    @unknown default:
                        fatalError("New thing here")
                    }
                }
                .onOpenURL { url in
                    print(url)
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
        
        Navigator.shared.appLaunchedFromNotification(response: response)
        completionHandler()
    }
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//
//
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//
//    }
    
    
    // The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print(notification ?? "nothing")
    }
}

extension AppDelegate: ObservableObject { }
