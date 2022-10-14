//
//  Tug.swift
//  Tugz
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation
import CloudKit

private let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    df.dateStyle = .none
    return df
}()

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    df.dateStyle = .long
    return df
}()

private let dayFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .medium
    return df
}()

final class Tug: Identifiable, Equatable, ObservableObject {
    
    let id: CKRecord.ID
    let minDurationToSave: TimeInterval = 15 /// tugs less than 15s not saved
    
    static func == (lhs: Tug, rhs: Tug) -> Bool {
        lhs.id == rhs.id
    }
    
    enum State: String {
        case scheduled
        case due
        case started
        case finished
        case skipped
        case cancelled
        case unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case scheduledFor
        case scheduledDuration
        case start
        case end
        case state
        case method
    }
    
    let scheduledFor: Date?
    let scheduledDuration: TimeInterval
    var start: Date? {
        willSet {
            objectWillChange.send()
        }
    }
    var end: Date? {
        willSet {
            objectWillChange.send()
        }
    }
    var state: State {
        willSet {
            objectWillChange.send()
        }
    }
    var method: Method = .manual(method: .other) /// published causes an update loop, idk
    
    var formattedStartTime: String {
        if let start = start {
            return timeFormatter.string(from: start)
        } else {
            return ""
        }
    }
    
    var formattedDate: String {
        if let date = start ?? scheduledFor {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    var formattedDay: String {
        guard let date = start ?? scheduledFor else {
            return ""
        }
        return dayFormatter.string(from: date)
    }
    
    var formattedScheduledEndTime: String {
        if let start = start {
            return timeFormatter.string(from: start.advanced(by: scheduledDuration))
        } else {
            return ""
        }
    }
    
    var duration: TimeInterval {
        if let start = start, let end = end {
            return end.timeIntervalSince(start)
        } else if let start = start {
            return -start.timeIntervalSinceNow
        }
        return 0
    }
    
    var percentDone: Double {
        switch state {
        case .scheduled, .due, .skipped, .cancelled, .unknown:
            return 0
        case .started:
            if let start = start {
                return Date().timeIntervalSince(start) / scheduledDuration
            } else {
                return 0
            }
        case .finished:
            if let start = start, let end = end {
                return end.timeIntervalSince(start) / scheduledDuration
            } else {
                return 1
            }
        }
    }
    
    init(scheduledFor: Date?, scheduledDuration: TimeInterval, start: Date? = nil, end: Date? = nil, state: State = .scheduled) {
        
        let record = CKRecord(recordType: "Tug")
        
        self.id = record.recordID
        self.scheduledFor = scheduledFor
        self.scheduledDuration = scheduledDuration
        self.start = start
        self.end = end
        self.state = state
    }
    
    init(record: CKRecord) {
        
        id = record.recordID
        
        scheduledFor = record[CodingKeys.scheduledFor.stringValue]
        if let duration = record[CodingKeys.scheduledDuration.stringValue] as? NSNumber {
            scheduledDuration = duration.doubleValue
        } else {
            scheduledDuration = 3 * 60
        }
        start = record[CodingKeys.start.stringValue]
        end = record[CodingKeys.end.stringValue]
        
        if let rawState = record[CodingKeys.state.stringValue] as? String, let state = State(rawValue: rawState) {
            self.state = state
        } else {
            state = .unknown
        }
        
        if let methodValue = record[CodingKeys.method.stringValue] as? String {
            
            if let manualMethod = ManualMethod(rawValue: methodValue) {
                method = .manual(method: manualMethod)
            } else if let device = Device(rawValue: methodValue) {
                method = .device(device: device)
            }
        }
    }
    
    func save() async throws {
        
        let db = Database.privateDb
        
        let record = CKRecord(recordType: "Tug", recordID: id) // CKRecord(recordType: "Tug")
//        let reference = CKRecord.Reference(recordID: record.recordID, action: .deleteSelf)
        
        record[CodingKeys.scheduledFor.stringValue] = scheduledFor
        record[CodingKeys.scheduledDuration.stringValue] = scheduledDuration
        record[CodingKeys.start.stringValue] = start
        record[CodingKeys.end.stringValue] = end
        record[CodingKeys.state.stringValue] = state.rawValue
        
        switch method {
        case .manual(let manualMethod):
            record[CodingKeys.method.stringValue] = manualMethod.rawValue
        case .device(let device):
            record[CodingKeys.method.stringValue] = device.rawValue
        }
        
        if duration > minDurationToSave && state != .cancelled {
            try await db.save(record)
        } else {
            try await db.deleteRecord(withID: record.recordID)
        }
    }
    
    func startTug() {
        
        assert(state == .due || state == .scheduled)
        
        start = Date()
        state = .started
    }
    
    func endTug() {
        
        assert(state == .started)
        
        end = Date()
        state = .finished
    }
    
    func cancelTug() {
        
        assert(state == .due || state == .started)
        
        state = .cancelled
    }
}

extension Tug {
    
    static func testTug(started: Bool = false, finished: Bool = false) -> Tug {
        
        let t = Tug(scheduledFor: Date(timeIntervalSinceNow: -Double.random(in: 0..<806400)), scheduledDuration: 60)
        if started {
            t.start = t.scheduledFor
        }
        if finished {
            t.end = t.start?.advanced(by: t.scheduledDuration)
        }
        return t
    }
    
    static func testTugInProgress() -> Tug {
        Tug(scheduledFor: Date(timeIntervalSinceNow: -30), scheduledDuration: 360, start: Date(timeIntervalSinceNow: -10), state: .started)
    }
    
    static func testDeviceTug() -> Tug {
        let t = Tug(scheduledFor: Date(timeIntervalSinceNow: -30), scheduledDuration: 360, start: Date(timeIntervalSinceNow: -10), state: .started)
        t.method = .device(device: .DTR)
        return t
    }
    
}

//extension Tug: CustomDebugStringConvertible {
//    var debugDescription: String {
//        "\(self) represents the post with title \"\(blogPost.title)\" and body \"\(blogPost.body)\""
//    }
//}
