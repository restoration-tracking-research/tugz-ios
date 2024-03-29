//
//  UserPrefs.swift
//  Tugz
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
        static let dailyGoalTugTime = Measurement(value: 30, unit: UnitDuration.minutes)
    }
    
    enum CodingKeys: String, CodingKey {
        case usesManual
        case usesDevices
        case tugDuration
        case tugInterval
        case firstTugTime
        case lastTugTime
        case userOwnedDevices
    }
    
    private let store = NSUbiquitousKeyValueStore.default
    
    @Published var usesManual = true
    @Published var usesDevices = false
    
    /// Each manual tug
    @Published var tugDuration: Measurement<UnitDuration> {
        didSet {
            save()
        }
    }
    @Published var tugInterval: Measurement<UnitDuration> { didSet { save() } }
    @Published var firstTugTime: DateComponents { didSet { save() } }
    @Published var lastTugTime: DateComponents { didSet { save() } }
    
    @Published var daysToTug: [DayOfWeek] { didSet { save() } }
    
    @Published var sendManualReminders = true
    
    private var onSaves = [()->()]()
    
    func onSave(_ callback: @escaping ()->()) {
        onSaves.append(callback)
    }
    
    /// Daily goals
    var dailyGoalTugTime: Measurement<UnitDuration> {
        tugDuration * Double(allDailyTugTimes().count)
    }
    
    @Published var userOwnedDevices = [Device]() { didSet { save() } }
    
    private let jsonEncoder = JSONEncoder()
    
    override init() {
        
        tugDuration = Defaults.tugDuration
        tugInterval = Defaults.tugInterval
        firstTugTime = Defaults.firstTugTime
        lastTugTime = Defaults.lastTugTime
        daysToTug = DayOfWeek.weekdays()
        
        super.init()
    }
    
    init(forTest: Bool) {
        
        tugDuration = Defaults.tugDuration
        tugInterval = Defaults.tugInterval
        firstTugTime = Defaults.firstTugTime
        lastTugTime = Defaults.lastTugTime
        daysToTug = DayOfWeek.weekdays()
        
        super.init()
        
        userOwnedDevices = [
            .DTR,
            .Foreskinned_Air,
            .Foreskinned_Gravity,
            .HyperRestore_Direct_Air
            ]
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding properties
        let usesManual = try values.decode(Bool.self, forKey: .usesManual)
        let usesDevices = try values.decode(Bool.self, forKey: .usesDevices)
        let tugDuration = try values.decode(TimeInterval.self, forKey: .tugDuration)
        let tugInterval = try values.decode(TimeInterval.self, forKey: .tugInterval)
        let firstTugTime = try values.decode([Int].self, forKey: .firstTugTime)
        let lastTugTime = try values.decode([Int].self, forKey: .lastTugTime)
        let userDevices = try values.decodeIfPresent([Device].self, forKey: .userOwnedDevices)
        
        // Safely set properties
        self.usesManual = usesManual
        self.usesDevices = usesDevices
        self.tugDuration = Measurement(value: tugDuration, unit: UnitDuration.seconds)
        self.tugInterval = Measurement(value: tugInterval, unit: UnitDuration.seconds)
        
        if let userDevices = userDevices, !userDevices.isEmpty {
            self.userOwnedDevices = userDevices
        } else {
            self.userOwnedDevices = Device.allCases
        }
        
        /// Temp
        self.firstTugTime = Defaults.firstTugTime
        self.lastTugTime = Defaults.lastTugTime
        self.daysToTug = DayOfWeek.weekdays()
        
        super.init()
        
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
        
        
        do {
            
            try values.encode(usesManual, forKey: .usesManual)
            try values.encode(usesDevices, forKey: .usesDevices)
            try values.encode(tugDuration.converted(to: .seconds).value, forKey: .tugDuration)
            try values.encode(tugInterval.converted(to: .seconds).value, forKey: .tugInterval)
            try values.encode([firstTugTime.hour, firstTugTime.minute], forKey: .firstTugTime)
            try values.encode([lastTugTime.hour, lastTugTime.minute], forKey: .lastTugTime)
            try values.encode(userOwnedDevices, forKey: .userOwnedDevices)
            
        } catch {
            print(error)
            print(error)
        }
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
        
        print(FileManager.default.urls(for: .preferencePanesDirectory, in: .userDomainMask).first!)
        
    
        do {
            let data = try jsonEncoder.encode(self)
            UserDefaults.standard.set(data, forKey: "UserPrefs")
        } catch {
            print(error)
        }
        
        onSaves.forEach { $0() }
    }
    
    func allDailyTugTimes() -> [DateComponents] {
        
        let cal = Calendar.current
        
        guard let dateOfFirstTug = cal.date(from: firstTugTime),
              let dateOfLastTug = cal.date(from: lastTugTime) else {
                  return [
                    cal.dateComponents([.calendar, .year, .month, .day, .hour, .minute, .second], from: Date(timeIntervalSinceNow: 60))
                    ]
              }
        
        var times = [DateComponents]()
        let nowComponents = cal.dateComponents([.calendar, .year, .month, .day], from: Date())
        
        var dateOfNextTug = dateOfFirstTug
        var dailyComponents = firstTugTime
        while dateOfNextTug.timeIntervalSince(dateOfLastTug) < 0 {
            
            let nextTugComponents = cal.dateComponents([.hour, .minute, .second], from: dateOfNextTug)

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
        
        var lastTime = lastTugTime
        lastTime.calendar = nowComponents.calendar
        lastTime.year = nowComponents.year
        lastTime.month = nowComponents.month
        lastTime.day = nowComponents.day
        times.append(lastTime)
        
        return times
    }
}
