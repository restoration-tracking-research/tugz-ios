//
//  Tug.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation

struct Tug: Codable {
    let start: Date
    let end: Date
    
    var duration: TimeInterval {
        end.timeIntervalSince(start)
    }
}
