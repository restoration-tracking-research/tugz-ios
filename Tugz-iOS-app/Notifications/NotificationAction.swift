//
//  NotificationAction.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 25/12/2021.
//

import UserNotifications

struct NotificationAction {
    
    enum Action: String {
        case tugNow
        case tugLater
        case skipThisTug
        case turnOffForToday
    }
    
    static let tugCategoryIdentifier = "TugNotification"
    
    static func register() {
        
        // Define the custom actions.
        let tugNowAction = UNNotificationAction(identifier: Action.tugNow.rawValue,
                                                title: "Tug Now",
                                                options: [.foreground])
        
        let tugLaterAction = UNNotificationAction(identifier: Action.tugLater.rawValue,
                                                title: "Remind me in 5 min",
                                                  options: [])
        
        let skipAction = UNNotificationAction(identifier: Action.skipThisTug.rawValue,
                                                title: "Skip This Tug",
                                                options: [])
        
        let turnOffAction = UNNotificationAction(identifier: Action.turnOffForToday.rawValue,
                                                title: "Turn Off For Today",
                                                 options: [.destructive])
        
        let actions = [tugNowAction, tugLaterAction, skipAction, turnOffAction]
        let category = UNNotificationCategory(identifier: tugCategoryIdentifier,
                                                           actions: actions,
                                                           intentIdentifiers: [],
                                                           hiddenPreviewsBodyPlaceholder: "",
                                                           options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
