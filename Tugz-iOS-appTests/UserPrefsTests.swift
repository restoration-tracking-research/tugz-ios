//
//  UserPrefsTests.swift
//  Tugz-iOS-appTests
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
}
