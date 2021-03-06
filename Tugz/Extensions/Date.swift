//
//  File.swift
//  Tugz
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation

extension DateComponents {
    
    func toDateInToday() -> Date {
        
        var c: DateComponents = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        
        c.hour = self.hour
        c.minute = self.minute
        return c.date!
    }
}

extension Date {
    var isToday: Bool { Calendar.current.isDateInToday(self) }
}

extension TimeInterval {
    
    var formatted: String {
        if hour > 0 {
            return String(format:"%d h %02d m", hour, minute)
        } else if minute > 0 {
            return String(format:"%d m %02d s", minute, second)
        } else {
            return String(format:"%d s", second)
        }
    }
    
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minuteSecond: String {
        String(format:"%d:%02d", minute, second)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
