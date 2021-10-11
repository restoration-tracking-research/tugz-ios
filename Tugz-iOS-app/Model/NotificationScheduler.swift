//
//  NotificationScheduler.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 06/10/2021.
//

import Foundation
import UserNotifications

private let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    df.dateStyle = .none
    return df
}()

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
            
            notification.title = "Tug time!"
            if let date = tugTime.date {
                notification.subtitle = "Scheduled for \(timeFormatter.string(from: date))"
            }
            notification.body = "Tap to get started."
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: tugTime, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    static func sendTestNotification() {
        
        let now = Calendar.current.dateComponents([.calendar, .day, .month, .year, .hour, .minute], from: Date())
        
        let notification = UNMutableNotificationContent()
        
        notification.title = "Test alert!"
        notification.body = "Tap to get started."
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: now, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print(error)
            }
        }
    }
    
}
