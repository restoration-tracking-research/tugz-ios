//
//  Navigator.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 11/10/2021.
//

import UIKit

class Navigator {
    
//    enum Tab: Int {
//        case home
//        case history
//        case preferences
//        case about
//    }
//
//    enum View {
//        case home
//        case tug
//    }
//
    static let shared = Navigator()
//
//
//    var isHome: Bool = true {
//        didSet {
//            if isHome {
//                activeView = .home
//            }
//        }
//    }
//
//    @Published var activeTab: Tab = .home
//    @Published var activeView: View = .home
    
    var needsToStartTugFromNotification = false
    
    private init() { }
    
    func appLaunchedFromNotification(response: UNNotificationResponse) {
        needsToStartTugFromNotification = true
    }
    
    func appDidHandleNotification() {
        needsToStartTugFromNotification = false
    }
    
    func appBackgrounded() {
        needsToStartTugFromNotification = false
    }
}
