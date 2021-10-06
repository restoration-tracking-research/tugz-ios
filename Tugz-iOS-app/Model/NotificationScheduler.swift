//
//  NotificationScheduler.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 06/10/2021.
//

import Foundation
import UserNotifications

struct NotificationScheduler {
    
    /// We will use device settings to decide how prominent to make the alerts
    let settings: DeviceSettings
    let prefs: UserPrefs
    let scheduler: Scheduler
    
    func request(_ callback: ((Bool)->())?) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            print("granted: \(granted ? "yes" : "no")")
            print(error ?? "no error")
            callback?(granted)
        }
    }
    
    func scheduleAlerts() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for tugTime in prefs.allDailyTugTimes() {
            
            let notification = UNMutableNotificationContent()
            if #available(iOS 15.0, *) {
                notification.interruptionLevel = .active
            }
            //                notification.body = "Tug time!"
            notification.title = "Tug time!"
            notification.subtitle = "Scheduled for \(scheduler.formattedTimeOfNextTug())"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: tugTime, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
}
