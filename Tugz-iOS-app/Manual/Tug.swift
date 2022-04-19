//
//  Tug.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation

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

final class Tug: Codable, Identifiable {
    
    enum State: String {
        case scheduled
        case due
        case started
        case finished
        case skipped
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
    var start: Date?
    var end: Date?
    var state: State
    var method: Method?
    
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
        }
        return 0
    }
    
    var percentDone: Double {
        switch state {
        case .scheduled, .due, .skipped:
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
        self.scheduledFor = scheduledFor
        self.scheduledDuration = scheduledDuration
        self.start = start
        self.end = end
        self.state = state
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding properties
        scheduledFor = try values.decodeIfPresent(Date.self, forKey: .scheduledFor)
        scheduledDuration = try values.decode(TimeInterval.self, forKey: .scheduledDuration)
        start = try values.decodeIfPresent(Date.self, forKey: .start)
        end = try values.decodeIfPresent(Date.self, forKey: .end)
        let rawState = try values.decode(String.self, forKey: .state)
        guard let state = State(rawValue: rawState) else {
            throw DecodingError.valueNotFound(State.self, DecodingError.Context(codingPath: [CodingKeys.state], debugDescription: "State not found", underlyingError: nil))
        }
        self.state = state
        self.method = try values.decodeIfPresent(Method.self, forKey: .method)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(scheduledFor, forKey: .scheduledFor)
        try values.encode(scheduledDuration, forKey: .scheduledDuration)
        try values.encode(start, forKey: .start)
        try values.encode(end, forKey: .end)
        try values.encode(state.rawValue, forKey: .state)
        try values.encode(method, forKey: .method)
    }
    
    func startTug() {
        
        assert(state == .due)
        
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
        
        state = .skipped
    }
}

extension Tug {
    
    static func testTug() -> Tug {
        Tug(scheduledFor: Date(), scheduledDuration: 60)
    }
    
    static func testTugInProgress() -> Tug {
        Tug(scheduledFor: Date(timeIntervalSinceNow: -30), scheduledDuration: 360, start: Date(timeIntervalSinceNow: -10), state: .started)
    }
}
