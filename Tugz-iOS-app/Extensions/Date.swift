//
//  File.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation

extension Date {
    
    var isToday: Bool { Calendar.current.isDateInToday(self) }
}
