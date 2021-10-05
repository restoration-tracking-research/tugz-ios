//
//  Scheduler.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation

/*
 Logic for "when's my next tug?"
 */

let oneDayInSeconds = Measurement(value: 24, unit: UnitDuration.hours).converted(to: .seconds).value
let oneHourInSeconds = Measurement(value: 1, unit: UnitDuration.hours).converted(to: .seconds).value

struct Scheduler {
    
    let prefs: UserPrefs
    let history: History
    
    private var components: DateComponents {
        Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
    }
    
    var firstTugTimeToday: Date? {
        var c = components
        c.hour = prefs.firstTugTime.hour
        c.minute = prefs.firstTugTime.minute
        return c.date
    }
    
    var lastTugTimeToday: Date? {
        var c = components
        c.hour = prefs.lastTugTime.hour
        c.minute = prefs.lastTugTime.minute
        return c.date
    }
    
    var firstTugTimeTomorrow: Date? {
        var c = components
        c.hour = prefs.firstTugTime.hour
        c.minute = prefs.firstTugTime.minute
        return c.date?.advanced(by: oneDayInSeconds)
    }
    
    var totalTugTimeToday: TimeInterval {
        history.tugs.reduce(0) { partialResult, t in
            t.end.isToday ? t.duration : 0
        }
    }
    
    func nextTug(after date: Date = Date()) -> Date? {
        guard let first = firstTugTimeToday,
              let last = lastTugTimeToday else {
                  return nil
              }
        
        /// If it's before the first tug of the day, show the first tug time
        if first.timeIntervalSince(date) > 0 {
            return first
        }
        /// If it's after the last tug of the day, show tomorrow's first tug
        else if last.timeIntervalSince(date) < 0,
                let tomorrowFirstTug = firstTugTimeTomorrow {
            return tomorrowFirstTug
        }
        /// Otherwise take the time the last tug started and add the tug interval
        else if let recent = history.lastTug {
            return recent.start.addingTimeInterval(prefs.tugInterval.converted(to: .seconds).value)
        }
        
        return nil
    }
    
    func timeUntilNextTug(from date: Date = Date()) -> TimeInterval? {
        nextTug()?.timeIntervalSince(date)
    }
    
    private let intervalFormatter = DateComponentsFormatter()
    private let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        return df
    }()
    
    func formattedTimeUntilNextTug(from date: Date = Date()) -> String {
        if let timeUntilNextTug = timeUntilNextTug(from: date), let string = intervalFormatter.string(from: timeUntilNextTug) {
            return string
        }
        return "(not scheduled)"
    }
    
    func formattedTimeOfNextTug(from date: Date = Date()) -> String {
        if let timeOfNextTug = nextTug(after: date) {
            return timeFormatter.string(from: timeOfNextTug)
        }
        return ""
    }
    
    func formattedTotalTugTimeToday() -> String {
        if totalTugTimeToday < oneHourInSeconds {
            if #available(iOS 15.0, *) {
                return Measurement(value: totalTugTimeToday, unit: UnitDuration.seconds).converted(to: .minutes).formatted()
            } else {
                return "\(Measurement(value: totalTugTimeToday, unit: UnitDuration.seconds).converted(to: .minutes).value)"
            }
        }
        return intervalFormatter.string(from: totalTugTimeToday) ?? "0 min"
    }
}
