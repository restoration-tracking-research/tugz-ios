//
//  UserPrefs.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation

/*
 Preferences specific to this user
 Such as:
 - How often do I tug?
 - How long do I tug for?
 */

struct UserPrefs: Codable {
    
    struct Defaults {
        static let tugDuration = Measurement(value: 3, unit: UnitDuration.minutes)
        static let tugInterval = Measurement(value: 1, unit: UnitDuration.hours)
        static let firstTugTime = DateComponents(hour: 9, minute: 0)
        static let lastTugTime = DateComponents(hour: 20, minute: 30)
        static let dailyGoalTugTime = Measurement(value: 40, unit: UnitDuration.minutes)
    }
    
    enum CodingKeys: String, CodingKey {
        case tugDuration
        case tugInterval
        case firstTugTime
        case lastTugTime
    }
    
    /// Each tug
    var tugDuration = Defaults.tugDuration
    var tugInterval = Defaults.tugInterval
    var firstTugTime = Defaults.firstTugTime
    var lastTugTime = Defaults.lastTugTime
    
    /// Daily goals
    var dailyGoalTugTime = Defaults.dailyGoalTugTime
    
    private let jsonEncoder = JSONEncoder()
    
    init() {
        tugDuration = Defaults.tugDuration
        tugInterval = Defaults.tugInterval
        firstTugTime = Defaults.firstTugTime
        lastTugTime = Defaults.lastTugTime
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding properties
        let tugDuration = try values.decode(TimeInterval.self, forKey: .tugDuration)
        let tugInterval = try values.decode(TimeInterval.self, forKey: .tugInterval)
        let firstTugTime = try values.decode([Int].self, forKey: .firstTugTime)
        let lastTugTime = try values.decode([Int].self, forKey: .lastTugTime)
        
        // Safely set properties
        self.tugInterval = Measurement(value: tugDuration, unit: UnitDuration.seconds)
        self.tugInterval = Measurement(value: tugInterval, unit: UnitDuration.seconds)
        
        if firstTugTime.count > 1 {
            self.firstTugTime.hour = firstTugTime[0]
            self.firstTugTime.minute = firstTugTime[1]
        }
        if lastTugTime.count > 1 {
            self.lastTugTime.hour = lastTugTime[0]
            self.lastTugTime.minute = lastTugTime[1]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(tugDuration.converted(to: .seconds).value, forKey: .tugDuration)
        try values.encode(tugInterval.converted(to: .seconds).value, forKey: .tugInterval)
        try values.encode([firstTugTime.hour, firstTugTime.minute], forKey: .firstTugTime)
        try values.encode([lastTugTime.hour, lastTugTime.minute], forKey: .lastTugTime)
    }
    
    static func load() -> Self {
        
        guard let data = UserDefaults.standard.object(forKey: "UserPrefs") as? Data else {
            return UserPrefs()
        }
        
        do {
            return try JSONDecoder().decode(UserPrefs.self, from: data)
        } catch {
            print(error)
            return UserPrefs()
        }
    }
    
    func save() {
        
        do {
            let data = try jsonEncoder.encode(self)
            UserDefaults.standard.set(data, forKey: "UserPrefs")
        } catch {
            print(error)
        }
    }
}
