//
//  SchedulerTests.swift
//  Tugz-iOS-appTests
//
//  Created by Charlie Williams on 04/10/2021.
//

import XCTest
@testable import Tugz

class SchedulerTests: XCTestCase {

    func testOneDayInSecondsValue() {
        XCTAssertEqual(oneDayInSeconds, 86400)
    }
    
    func testSchedulerNextTugAt8AMis9AM() {
        
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.hour = 8
        components.minute = 0
        components.second = 0
        let date = components.date!
        
        var c2 = components
        c2.hour = 9
        let expectedDate = c2.date!
        
        let u = UserPrefs()
        let h = History(tugs: [Tug(scheduledFor: Date(), scheduledDuration: 60, start: Date(), end: Date())])
        let s = Scheduler(prefs: u, history: h)
        
        XCTAssertEqual(s.nextTug(after: date), expectedDate)
    }
    
    func testSchedulerNextTugLateIsNextDayFirstTug() {
        
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.hour = 23
        components.minute = 0
        components.second = 0
        let date = components.date!
        
        var c2 = components
        c2.hour = 9
        let expectedDate = c2.date!.advanced(by: oneDayInSeconds)
        
        let u = UserPrefs()
        let h = History(tugs: [Tug(scheduledFor: Date(), scheduledDuration: 60, start: Date(), end: Date())])
        let s = Scheduler(prefs: u, history: h)
        
        XCTAssertEqual(s.nextTug(after: date), expectedDate)
    }
    
    func testSchedulerAddsTimeFromLastTug() {
        
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.hour = 10
        components.minute = 0
        components.second = 0
        let date = components.date!
        
        var c2 = components
        c2.hour = 11
        let expectedDate = c2.date!
        
        let u = UserPrefs()
        let h = History(tugs: [Tug(scheduledFor: Date(), scheduledDuration: 60, start: date, end: date)])
        let s = Scheduler(prefs: u, history: h)
        
        XCTAssertEqual(s.nextTug(after: date), expectedDate)
    }
    
    func testFormattedTimeUntilNextTug() {
        
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.hour = 10
        components.minute = 0
        components.second = 0
        let date = components.date!
        
        let u = UserPrefs()
        let h = History(tugs: [Tug(scheduledFor: date, scheduledDuration: 60, start: date, end: date)])
        let s = Scheduler(prefs: u, history: h)
        
        XCTAssertEqual(s.formattedTimeUntilNextTug(from: date), "1:00:00")
    }
    
    func testFormattedTimeOfNextTug() {
        
        var components = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: Date())
        components.hour = 10
        components.minute = 0
        components.second = 0
        let date = components.date!
        
        let u = UserPrefs()
        let h = History(tugs: [Tug(scheduledFor: Date(), scheduledDuration: 60, start: date, end: date)])
        let s = Scheduler(prefs: u, history: h)
        
        XCTAssertEqual(s.formattedTimeOfNextTug(from: date), "11:00 AM")
    }
}