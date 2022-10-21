//
//  UserPrefsTests.swift
//  TugzTests
//
//  Created by Charlie Williams on 06/10/2021.
//

import XCTest
@testable import Tugz

class UserPrefsTests: XCTestCase {

    func testAllDailyTugTimes() {
        
        let prefs = UserPrefs()
        
        XCTAssertEqual(prefs.allDailyTugTimes().count, 13)
    }
    
    func testSaveAndLoad() {
        
        let testDuration = Measurement(value: 7, unit: UnitDuration.minutes)
        
        let prefs = UserPrefs()
        
        XCTAssertNotEqual(prefs.tugDuration, testDuration)
        
        prefs.tugDuration = testDuration
        
        let loaded = UserPrefs.loadFromStore()
        
        XCTAssertEqual(loaded.tugDuration, testDuration)
    }
}
