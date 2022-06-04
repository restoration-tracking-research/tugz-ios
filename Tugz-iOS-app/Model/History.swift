//
//  History.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/10/2021.
//

import Foundation
import CloudKit

/*
 The record of past tugs
 */

final class History: NSObject, ObservableObject {
    
    enum FetchState {
        case notFetched
        case fetching(date: Date)
        case fetched(date: Date)
        case error(error: Error)
    }
    
    var fetchState = FetchState.notFetched
    
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
    
//    static func loadFromStore() -> History {
//
//        guard let data = UserDefaults.standard.object(forKey: "History") as? Data else {
//            return History(tugs: [])
//        }
//
//        do {
//            let history = try JSONDecoder().decode(History.self, from: data)
//            return history
//        } catch {
//            print(error)
//            return History(tugs: [])
//        }
//    }
    
    override init() {
        self.tugs = []
        
        super.init()

        Task.init {
            do {
                fetchState = .fetching(date: Date())
                try await fetchFromCloud()
            } catch {
                print(error)
                fetchState = .error(error: error)
            }
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
    
    func fetchFromCloud() async throws {
        
        /// We can only see our own tugs, so we can just request "all of them"
        let query = CKQuery(recordType: "Tug", predicate: NSPredicate(value: true))
        let db = CKContainer.default().privateCloudDatabase
        
        let tuple = try await db.records(matching: query)
        
        let tugs = try tuple.matchResults
            .compactMap { try $1.get() }
            .compactMap { Tug(record: $0 ) }
        
        self.tugs = tugs
        
        fetchState = .fetched(date: Date())
    }
    
    func append(_ tug: Tug) {
        
        tugs.append(tug)
        Task.init {
            do {
                try await tug.save()
            } catch {
                print(error)
            }
        }
    }
    
    func save() {
        
        /// I don't think we need to do 'save' anymore
        
//        CKContainer.default().privateCloudDatabase.sa
        
        /// CloudKit save

        
        /// UserDefaults save
//        do {
//            let data = try jsonEncoder.encode(self)
//            UserDefaults.standard.set(data, forKey: "History")
//        } catch {
//            print(error)
//        }
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
        
        print("History: \(sortedByDate.count) tugs \(includingToday ? "including today" : "not including today"). \(tugs.count) tugs total.")

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
