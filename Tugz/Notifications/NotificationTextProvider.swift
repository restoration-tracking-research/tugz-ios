//
//  NotificationTextProvider.swift
//  Tugz
//
//  Created by Charlie Williams on 24/12/2021.
//

import Foundation

/// TODO let people pick a level of misdirection for the push text
struct NotificationTextProvider {
    
    enum Time {
        case first
        case mid
        case last
    }
    
    func title(for index: Int?, of max: Int?) -> String {
        
        guard let index = index, let max = max else {
            return title(for: .mid)
        }
        
        if index == 0 {
            return title(for: .first)
        } else if index >= max - 1 {
            return title(for: .last)
        } else {
            return title(for: .mid)
        }
    }
    
    func body(for index: Int?, of max: Int?) -> String {
        
        guard let index = index, let max = max else {
            return body(for: .mid)
        }
        
        if index == 0 {
            return body(for: .first)
        } else if index >= max - 1 {
            return body(for: .last)
        } else {
            return body(for: .mid)
        }
    }
    
    func title(for time: Time) -> String {
        
        switch time {
        case .first:
            return titleForFirstTugOfDay()
        case .mid:
            return [
                "Tug time!",
                "Let's make some progress",
                "Ready to restore?"
            ].randomElement()!
        case .last:
            return titleForLastTugOfDay()
        }
        
    }
    
    func body(for time: Time) -> String {
        
        switch time {
        case .first:
            return bodyForFirstTugOfDay()
        case .mid:
            return [
                "Tap to get started.",
                "Find a good location and tap to continue",
                "When you're ready to start, tap here"
            ].randomElement()!
        case .last:
            return bodyForLastTugOfDay()
        }
    }
    
    func titleForFirstTugOfDay() -> String {
        "Good morning! Let's get tugging."
    }
    
    func bodyForFirstTugOfDay() -> String {
        "Start off strong!"
    }
    
    func titleForLastTugOfDay() -> String {
        "Last tug of the day starting…"
    }
    
    func bodyForLastTugOfDay() -> String {
        "Let's make it a good one!"
    }
}
