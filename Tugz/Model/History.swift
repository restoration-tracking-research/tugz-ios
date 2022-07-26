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
    
    static let shared = History()
    
    enum FetchState {
        case notFetched
        case fetching(date: Date)
        case fetched(date: Date)
        case error(error: Error)
    }
    
    private(set) var tugs: [Tug] {
        willSet {
            objectWillChange.send()
        }
    }
    
    private(set) var fetchState = FetchState.notFetched
    
    private let refreshInterval: TimeInterval = 60 * 60
    
    enum CodingKeys: String, CodingKey {
        case tugs
    }
    
    var lastTug: Tug? {
        tugs.last
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
    
    override private init() {
        self.tugs = []
        
        super.init()

        fetchIfNeeded()
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
    
    func fetchIfNeeded() {
        
        switch fetchState {
            
        case .notFetched, .error(_):
            _fetchImpl()
        case .fetching(let date), .fetched(let date):
            if date.timeIntervalSinceNow < refreshInterval {
                _fetchImpl()
            }
        }
    }
    
    func _fetchImpl() {
        Task.init {
            await self.fetchFromCloud()
        }
    }
    
    func handle(error: Error) {
        
        fetchState = .error(error: error)
        
        /// TODO lol
        print(error)
        
        
        /// What could happen here?
        /// Tug fails to save
        /// Do we store it locally and try again?
        /// Alert the user?
    }
    
    func fetchFromCloud() async {
        
        fetchState = .fetching(date: Date())
        
        /// We can only see our own tugs, so we can just request "all of them"
        let query = CKQuery(recordType: "Tug", predicate: NSPredicate(value: true))
        let db = Database.privateDb
        
        do {
            
            let tuple = try await db.records(matching: query)
            
            let tugs = try tuple.matchResults
                .compactMap { try $1.get() }
                .compactMap { Tug(record: $0 ) }
                .filter { $0.start != nil } /// Don't show scheduled ones
                .sorted { $0.start!.timeIntervalSince1970 > $1.start!.timeIntervalSince1970 }
            
            self.tugs = tugs
            
            fetchState = .fetched(date: Date())
            
        } catch {
            
            handle(error: error)
        }
    }
    
    func append(_ tug: Tug) {
        
        tugs.insert(tug, at: 0)
        Task.init {
            do {
                try await tug.save()
            } catch {
                handle(error: error)
            }
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
