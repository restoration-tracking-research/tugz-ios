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

final class UserPrefs: NSObject, Codable, ObservableObject {
    
    struct Defaults {
        static let tugDuration = Measurement(value: 3, unit: UnitDuration.minutes)
        static let tugInterval = Measurement(value: 1, unit: UnitDuration.hours)
        static let firstTugTime = DateComponents(hour: 9, minute: 0)
        static let lastTugTime = DateComponents(hour: 20, minute: 30)
        static let dailyGoalTugTime = Measurement(value: 180, unit: UnitDuration.minutes)
    }
    
    enum CodingKeys: String, CodingKey {
        case usesManual
        case usesDevices
        case tugDuration
        case tugInterval
        case firstTugTime
        case lastTugTime
        case userOwnedDevices
        case dailyGoalTugTime
    }
    
    @Published var usesManual = true
    @Published var usesDevices = false
    
    /// Each manual tug
    @Published var tugDuration: Measurement = Defaults.tugDuration { didSet { save() } }
    @Published var tugInterval: Measurement = Defaults.tugInterval { didSet { save() } }
    @Published var firstTugTime: DateComponents = Defaults.firstTugTime { didSet { save() } }
    @Published var lastTugTime: DateComponents = Defaults.lastTugTime { didSet { save() } }
    
    @Published var daysToTug: [DayOfWeek] = DayOfWeek.weekdays() { didSet { save() } }
    
    @Published var sendManualReminders = true
    
    /// Daily goals
    @Published var dailyGoalTugTime: Measurement = Defaults.dailyGoalTugTime { didSet { save() } }
    
    @Published var userOwnedDevices = [Device]() { didSet { save() } }
    
    private let jsonEncoder = JSONEncoder()
    
    override init() {
        super.init()
    }
    
    init(forTest: Bool) {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding properties
        let usesManual = try values.decode(Bool.self, forKey: .usesManual)
        let usesDevices = try values.decode(Bool.self, forKey: .usesDevices)
        let tugDuration = try values.decode(TimeInterval.self, forKey: .tugDuration)
        let tugInterval = try values.decode(TimeInterval.self, forKey: .tugInterval)
        let dailyGoalTugTime = try values.decodeIfPresent(TimeInterval.self, forKey: .dailyGoalTugTime)
        let firstTugTime = try values.decode([Int].self, forKey: .firstTugTime)
        let lastTugTime = try values.decode([Int].self, forKey: .lastTugTime)
        let userDevices = try values.decodeIfPresent([Device].self, forKey: .userOwnedDevices)
        
        // Safely set properties
        self.usesManual = usesManual
        self.usesDevices = usesDevices
        self.tugInterval = Measurement(value: tugDuration, unit: UnitDuration.seconds)
        self.tugInterval = Measurement(value: tugInterval, unit: UnitDuration.seconds)
        self.userOwnedDevices = userDevices ?? []

        if let dailyGoalTugTime = dailyGoalTugTime {
            self.dailyGoalTugTime = Measurement(value: dailyGoalTugTime, unit: UnitDuration.seconds)
        }
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
        
        try values.encode(usesManual, forKey: .usesManual)
        try values.encode(usesDevices, forKey: .usesDevices)
        try values.encode(tugDuration.converted(to: .seconds).value, forKey: .tugDuration)
        try values.encode(tugInterval.converted(to: .seconds).value, forKey: .tugInterval)
        try values.encode([firstTugTime.hour, firstTugTime.minute], forKey: .firstTugTime)
        try values.encode([lastTugTime.hour, lastTugTime.minute], forKey: .lastTugTime)
        try values.encode(userOwnedDevices, forKey: .userOwnedDevices)
        try values.encode(dailyGoalTugTime.converted(to: .seconds).value, forKey: .dailyGoalTugTime)
    }
    
    static func loadFromStore() -> UserPrefs {
        
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
    
    func allDailyTugTimes() -> [DateComponents] {
        
        let cal = Calendar.current
        
        guard let dateOfFirstTug = cal.date(from: firstTugTime),
              let dateOfLastTug = cal.date(from: lastTugTime) else {
                  return []
              }
        
        var times = [DateComponents]()
                
        var dateOfNextTug = dateOfFirstTug
        var dailyComponents = firstTugTime
        while dateOfNextTug.timeIntervalSince(dateOfLastTug) < 0 {
            
            let nextTugComponents = cal.dateComponents([.hour, .minute, .second], from: dateOfNextTug)
            let nowComponents = cal.dateComponents([.calendar, .year, .month, .day], from: Date())
            
            dailyComponents.calendar = nowComponents.calendar
            dailyComponents.year = nowComponents.year
            dailyComponents.month = nowComponents.month
            dailyComponents.day = nowComponents.day
            dailyComponents.hour = nextTugComponents.hour
            dailyComponents.minute = nextTugComponents.minute
            dailyComponents.second = nextTugComponents.second
            
            /// Advance and re-check
            dateOfNextTug = dateOfNextTug.advanced(by: tugInterval.converted(to: .seconds).value)
            
            times.append(dailyComponents)
        }
        
        times.append(lastTugTime)
        
        return times
    }
}
