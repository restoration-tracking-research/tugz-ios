//
//  History.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation

/*
 The record of past tugs
 */

struct History: Codable {
    
    enum CodingKeys: String, CodingKey {
        case tugs
    }
    
    var lastTug: Tug? {
        tugs.last
    }
    var tugs: [Tug]
    
    private let jsonEncoder = JSONEncoder()
    
    static func load() -> Self {
        
        guard let data = UserDefaults.standard.object(forKey: "History") as? Data else {
            
            /// TEMP DEBUG DATA
            return History(tugs: [Tug(scheduledFor: Date(timeIntervalSinceNow: -86400), scheduledDuration: 60, start: Date(timeIntervalSinceNow: -86400), end: Date(timeIntervalSinceNow: 86300)),
                                  Tug(scheduledFor: Date(timeIntervalSinceNow: -3000), scheduledDuration: 60, start: Date(timeIntervalSinceNow: -3000), end: Date(timeIntervalSinceNow: -2000))])
        }
        
        do {
            return try JSONDecoder().decode(History.self, from: data)
        } catch {
            print(error)
            return History(tugs: [])
        }
    }
    
    func save() {
        
        do {
            let data = try jsonEncoder.encode(self)
            UserDefaults.standard.set(data, forKey: "History")
        } catch {
            print(error)
        }
    }
}
