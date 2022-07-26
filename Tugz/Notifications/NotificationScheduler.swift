//
//  NotificationScheduler.swift
//  Tugz
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
    let scheduler: TugScheduler
    
    var components: Set<Calendar.Component> { [.calendar, .year, .month, .day, .hour, .minute, .timeZone] }
    
    var dayComponents: Set<Calendar.Component> { [.calendar, .day, .hour, .minute, .timeZone] }
    
    func request(_ callback: ((Bool)->())?) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            print("granted: \(granted ? "yes" : "no")")
            print(error ?? "no error")
            callback?(granted)
        }
    }
    
    private func buildContent(tugTime: DateComponents, index: Int?, of max: Int?, textProvider: NotificationTextProvider = NotificationTextProvider()) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        
        content.title = textProvider.title(for: index, of: max)
        if let date = Calendar.current.date(from: tugTime) {
            content.subtitle = "Scheduled for \(timeFormatter.string(from: date))"
        }
        content.body = textProvider.body(for: index, of: max)
        content.categoryIdentifier = NotificationAction.tugCategoryIdentifier
        if let index = index, let max = max {
            content.userInfo = ["index": index, "max": max]
        }
        
        return content
    }
    
    func scheduleAlerts(addingDays: Int = 0) {
        
        cancelAll()
        
        let textProvider = NotificationTextProvider()
        
        let all = prefs.allDailyTugTimes()
        for (index, tugTime) in all.enumerated() {
            
            let notification = buildContent(tugTime: tugTime, index: index, of: all.count, textProvider: textProvider)
            
            guard let tugDate = Calendar.current.date(from: tugTime),
                  let scheduledTugTime = Calendar.current.date(byAdding: .day, value: addingDays, to: tugDate) else {
                      
                      print("wtf")
                      return
                  }
            
            schedule(notification: notification, at: scheduledTugTime)
        }
    }
    
    func rescheduleTug(inMinutes minutes: Double, userInfo: [AnyHashable: Any]) {
        
        let due = Date(timeIntervalSinceNow: minutes * 60)
        let comp = Calendar.current.dateComponents(components, from: due)
        let notification = buildContent(tugTime: comp, index: userInfo["index"] as? Int, of: userInfo["max"] as? Int)
        
        schedule(notification: notification, at: due)
    }
    
    private func schedule(notification: UNMutableNotificationContent, at date: Date) {
        
        let scheduledTugComponents = Calendar.current.dateComponents(dayComponents, from: date)
        
        
        
        /// Debug
//        let scheduledTugComponents = Calendar.current.dateComponents(components, from: Date(timeIntervalSinceNow: 15))
        /// End debug
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: scheduledTugComponents, repeats: true)
        
        /// Use the same identifier always, so that new ones replace old ones
        let identifier = "uQPr9d56Ez2g7MymcATt3f8uuTPdRd56sMDbL4xp"
        
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print(error)
            }
        }
    }
    
    func cancelTodayAndRescheduleTomorrow() {
        
        cancelAll()
        
        scheduleAlerts(addingDays: 1)
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension NotificationScheduler {
    
    static func sendTestNotification() {
        
        let now = Calendar.current.dateComponents([.calendar, .day, .month, .year, .hour, .minute, .second, .timeZone], from: Date(timeIntervalSinceNow: 1))
//        now.second = now.second ?? 0 + 10
        
        let content = UNMutableNotificationContent()
        
        content.title = "Test alert!"
        content.subtitle = "Can you see the subtitle?"
        content.body = "Tap to get started."
        content.categoryIdentifier = NotificationAction.tugCategoryIdentifier
        content.userInfo = ["index": 0, "max": 10]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: now, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print(error)
            }
        }
    }
}
