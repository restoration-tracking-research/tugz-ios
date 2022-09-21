//
//  Scheduler.swift
//  Tugz
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation

/*
 Logic for "when's my next tug?"
 */

let oneDayInSeconds = Measurement(value: 24, unit: UnitDuration.hours).converted(to: .seconds).value
let oneHourInSeconds = Measurement(value: 1, unit: UnitDuration.hours).converted(to: .seconds).value

final class TugScheduler: ObservableObject {
    
    let prefs: UserPrefs
    let history: History
    
    private let intervalFormatter = DateComponentsFormatter()
    private let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        return df
    }()
    
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
            partialResult + (t.end?.isToday == true ? t.duration : 0)
        }
    }

    var percentDoneToday: Double {
        totalTugTimeToday / prefs.dailyGoalTugTime.converted(to: .seconds).value
    }
    
    var todaySessionCount: Int {
        history.tugs.filter { $0.end?.isToday == true }.count
    }
    
    init(prefs: UserPrefs, history: History) {
        
        self.prefs = prefs
        self.history = history
    }
    
    private var _activeTug: Tug? {
        willSet {
            if let _activeTug = _activeTug, let newValue = newValue {
                assert(_activeTug.state != .started)
                assert(newValue.state != .started)
            }
        }
    }
    
    func activeTug() -> Tug {
        
        /// If there's an active tug, return it
        if let _activeTug = _activeTug {
            
            if _activeTug.state == .finished {
                self._activeTug = nil
            } else {
                return _activeTug
            }
        }
        
        let tug: Tug
        
        /// If there's a tug scheduled for now, but not started, return that one
        let duration = prefs.tugDuration.converted(to: .seconds).value
        let tugDelta = prefs.tugInterval.converted(to: .seconds).value / 5
        
        if let nextTugTime = timeOfNextTug(), nextTugTime.timeIntervalSinceNow.magnitude < tugDelta {
             tug = Tug(scheduledFor: nextTugTime, scheduledDuration: duration, state: .due)
        } else {
            /// Otherwise make a new one
            tug = Tug(scheduledFor: nil, scheduledDuration: duration, state: .due)
        }
        
        _activeTug = tug
        return tug
    }
}

/// Query
extension TugScheduler {
    
    func timeOfNextTug(after date: Date = Date()) -> Date? {
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
        else if let recent = history.lastTug, recent.end?.isToday == true {
            return recent.start?.addingTimeInterval(prefs.tugInterval.converted(to: .seconds).value)
        }
        /// If we have no last tug, figure out when the next one should be according to the daily schedule
        else {
            var next = first.toGlobalTime()
            while next.timeIntervalSinceNow < 0 {
                next.addTimeInterval(prefs.tugInterval.converted(to: .seconds).value)
            }
            return next
        }
    }
    
    func timeUntilNextTug(from date: Date = Date()) -> TimeInterval? {
        timeOfNextTug()?.timeIntervalSince(date)
    }
}

/// Formatting
extension TugScheduler {
    
    func formattedTimeUntilNextTug(from date: Date = Date()) -> String {
        
        guard let timeUntilNextTug = timeUntilNextTug(from: date), let string = intervalFormatter.string(from: timeUntilNextTug) else {
            return "(not scheduled)"
        }
            
        if timeUntilNextTug < 0 {
            return "Due now"
        }
        else if timeUntilNextTug < 60 {
            return string
        }
        else if timeUntilNextTug < 3600 {
            return "\(Int(timeUntilNextTug / 60)) min"
        }
        else {
            return "\(Int(timeUntilNextTug / 3600)) hr"
        }
    }
    
    func formattedTimeOfNextTug(from date: Date = Date()) -> String {
        if let timeOfNextTug = timeOfNextTug(after: date) {
            return timeFormatter.string(from: timeOfNextTug)
        }
        return ""
    }
    
    func formattedTotalTugTimeToday() -> String {
        format(totalTugTimeToday)
    }
    
    func formattedPercentDoneToday() -> String {
        if percentDoneToday > 0 {
            return "\(percentDoneToday * 100) %"
        }
        return "-"
    }
    
    func formattedGoalTimeToday() -> String {
        format(prefs.dailyGoalTugTime.converted(to: .seconds).value)
    }
    
    func formattedProgressString() -> String {
        if percentDoneToday == 0 {
            return "\(formattedGoalTimeToday()) daily goal"
        } else {
            return "\(formattedPercentDoneToday()) of \(formattedGoalTimeToday()) goal"
        }
    }
    
    private func format(_ timeInterval: TimeInterval) -> String {
        
        if timeInterval < 60 {
            return "\(Int(timeInterval)) sec"
        }
        if timeInterval < oneHourInSeconds {
            return "\(timeInterval.minute) min"
        }
        return "\(timeInterval.hour) h \(timeInterval.minute) min"
    }
}
