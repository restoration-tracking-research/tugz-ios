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

    var body: some Scene {
        
        WindowGroup {
            
            let prefs = UserPrefs.load()
            let history = History.load()
            let settings = DeviceSettings.load()
            let scheduler = Scheduler(prefs: prefs, history: history)
            
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
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var app: TugzApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        NotificationAction.register()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Navigator.shared.appBackgrounded()
        
        /// Send debug test notification
        NotificationScheduler.sendTestNotification()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Navigator.shared.appBackgrounded()
        
        /// Send debug test notification
        NotificationScheduler.sendTestNotification()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        Navigator.shared.appLaunchedFromNotification(response: response)
        completionHandler()
    }
}

extension AppDelegate: ObservableObject {
    
    
}
