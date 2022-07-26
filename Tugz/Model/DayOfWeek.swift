//
//  Weekday.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 15/05/2022.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var initial: String {
        String(rawValue.first!).capitalized
    }
    
    static func weekdays() -> [DayOfWeek] {
        [.monday, .tuesday, .wednesday, .thursday, .friday]
    }
}
