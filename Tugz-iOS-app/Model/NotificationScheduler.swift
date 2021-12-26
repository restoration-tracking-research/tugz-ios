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
    
    var components: Set<Calendar.Component> { [.calendar, .year, .month, .day, .hour, .minute] }
    
    func request(_ callback: ((Bool)->())?) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            print("granted: \(granted ? "yes" : "no")")
            print(error ?? "no error")
            callback?(granted)
        }
    }
    
    private func buildContent(tugTime: DateComponents, textProvider: NotificationTextProvider = NotificationTextProvider()) -> UNMutableNotificationContent {
        
        let notification = UNMutableNotificationContent()
        if #available(iOS 15.0, *) {
            notification.interruptionLevel = .timeSensitive
        }
        
        notification.title = textProvider.title()
        if let date = Calendar.current.date(from: tugTime) {
            notification.subtitle = "Scheduled for \(timeFormatter.string(from: date))"
        }
        notification.body = textProvider.body()
        notification.categoryIdentifier = NotificationAction.tugCategoryIdentifier
        
        return notification
    }
    
    func scheduleAlerts(addingDays: Int = 0) {
        
        cancelAll()
        
        let textProvider = NotificationTextProvider()
        
        for tugTime in prefs.allDailyTugTimes() {
            
            let notification = buildContent(tugTime: tugTime, textProvider: textProvider)
            
            guard let tugDate = Calendar.current.date(from: tugTime),
                  let scheduledTugTime = Calendar.current.date(byAdding: .day, value: addingDays, to: tugDate) else {
                      
                      print("wtf")
                      return
                  }
            
            schedule(notification: notification, at: scheduledTugTime)
        }
    }
    
    func rescheduleTug(inMinutes minutes: Double) {
        
        let due = Date(timeIntervalSinceNow: minutes * 60)
        let comp = Calendar.current.dateComponents(components, from: due)
        let notification = buildContent(tugTime: comp)
        
        schedule(notification: notification, at: due)
    }
    
    private func schedule(notification: UNMutableNotificationContent, at date: Date) {
        
        let scheduledTugComponents = Calendar.current.dateComponents(components, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: scheduledTugComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print(error)
            }
        }
    }
    
    func cancelTodayAndRescheduleTomorrow() {
        
//        let c = UNUserNotificationCenter.current()
//        c.getPendingNotificationRequests { requests in
//
//            let todayNotificationsToRemove: [String] = requests.compactMap { request in
//
//                if let t = request.trigger as? UNCalendarNotificationTrigger,
//                   t.nextTriggerDate()?.isToday == true {
//                    return request.identifier
//                }
//                return nil
//            }
//
//            c.removePendingNotificationRequests(withIdentifiers: todayNotificationsToRemove)
//        }
        
        cancelAll()
        
        scheduleAlerts(addingDays: 1)
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension NotificationScheduler {
    
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
