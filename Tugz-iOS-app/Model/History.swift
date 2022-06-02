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

final class History: NSObject, Codable, ObservableObject {
    
    enum CodingKeys: String, CodingKey {
        case tugs
    }
    
    var lastTug: Tug? {
        tugs.last
    }
    private(set) var tugs: [Tug] {
        didSet {
            self.tugs = tugs
                .filter { $0.start != nil }
                .sorted { $0.start!.timeIntervalSince1970 > $1.start!.timeIntervalSince1970 }
        }
    }
    
    var lastManualMethod: ManualMethod? {
        
        for tug in tugs.reversed() {
            if case .manual(let method) = tug.method {
                return method
            }
        }
        return nil
    }
    
    var lastDevice: Device? {
        
        for tug in tugs.reversed() {
            if case .device(let device) = tug.method {
                return device
            }
        }
        return nil
    }
    
    private let jsonEncoder = JSONEncoder()
    
    static func loadFromStore() -> History {
        
        guard let data = UserDefaults.standard.object(forKey: "History") as? Data else {
            return History(tugs: [])
        }
        
        do {
            let history = try JSONDecoder().decode(History.self, from: data)
            return history
        } catch {
            print(error)
            return History(tugs: [])
        }
    }
    
    init(tugs: [Tug]) {
        self.tugs = tugs
        
        super.init()
    }
    
    init(forTest: Bool) {
        self.tugs = [
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true),
            Tug.testTug(started: true, finished: true)
            ]
        
        super.init()
    }
    
    func append(_ tug: Tug) {
        tugs.append(tug)
        save()
    }
    
    func save() {
        
        do {
            let data = try jsonEncoder.encode(self)
            UserDefaults.standard.set(data, forKey: "History")
        } catch {
            print(error)
        }
    }
    
    /// TODO provide summary stats per day
    /// rather than just a list of individual tugs
    func tugsToday() -> [Tug] {
        tugs.filter { $0.start?.isToday == true }
    }
    
    func tugsByDay(includingToday: Bool) -> [[Tug]] {
        
        var sortedByDate = [[Tug]]()

        /// For each tug
        for tug in tugs {
            
            /// If we're not doing today, and it's today, go to the next tug
            if !includingToday && tug.start?.isToday == true {
                continue
            }

            /// Look in the existing set to see if there's already a group for "today"
            var found = false
            for (index, existingArr) in sortedByDate.enumerated() {

                if let start = tug.start, Calendar.current.isDate(start, inSameDayAs: existingArr.first!.start!) {
                    sortedByDate[index].append(tug)
                    found = true
                    continue
                }
            }
            
            if !found {
                sortedByDate.append([tug])
            }
        }

        return sortedByDate
    }
    
    func tugsTaggedByDay(includingToday: Bool) -> [Date: [Tug]] {
        
        let tugArrs = tugsByDay(includingToday: includingToday)
        
        var tagged = [Date: [Tug]]()
        
        for tugArr in tugArrs {
            if let start = tugArr.first?.start {
                tagged[start] = tugArr
            }
        }
        
        return tagged
    }
}
