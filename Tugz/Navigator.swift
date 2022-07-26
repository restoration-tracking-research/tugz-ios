//
//  Navigator.swift
//  Tugz
//
//  Created by Charlie Williams on 11/10/2021.
//

import SwiftUI

final class Navigator {
    
    let config: Config
    
    var needsToStartTugFromNotification = false
    
    init(config: Config) {
        self.config = config
    }
    
    private func scheduler() -> NotificationScheduler {
        return NotificationScheduler(settings: config.settings, prefs: config.prefs, scheduler: config.scheduler)
    }
    
    func appLaunchedFromNotification(response: UNNotificationResponse) {
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            needsToStartTugFromNotification = true
            return
        }
        
        let userInfo = response.notification.request.content.userInfo
        
        if let action = NotificationAction.Action(rawValue: response.actionIdentifier) {
        
            switch action {
                
            case .tugNow:
                needsToStartTugFromNotification = true
                
            case .tugLater:
                scheduler().rescheduleTug(inMinutes: 5, userInfo: userInfo)
                
            case .skipThisTug:
                needsToStartTugFromNotification = false
                
            case .turnOffForToday:
                scheduler().cancelTodayAndRescheduleTomorrow()
            }
            
        } else {
            
            print("Couldn't handle action!")
            print(response)
        }
    }
    
    func appDidHandleNotification() {
        needsToStartTugFromNotification = false
    }
    
    func appBackgrounded() {
        needsToStartTugFromNotification = false
    }
}
