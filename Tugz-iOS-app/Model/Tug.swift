//
//  Tug.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 05/10/2021.
//

import Foundation

final class Tug: Codable {
    
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
    }
    
    let scheduledFor: Date
    let scheduledDuration: TimeInterval
    var start: Date?
    var end: Date?
    var state: State
    
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
                return min(Date().timeIntervalSince(start) / scheduledDuration, 1)
            } else {
                return 0
            }
        case .finished:
            return 1
        }
    }
    
    init(scheduledFor: Date, scheduledDuration: TimeInterval, start: Date? = nil, end: Date? = nil, state: State = .scheduled) {
        self.scheduledFor = scheduledFor
        self.scheduledDuration = scheduledDuration
        self.start = start
        self.end = end
        self.state = state
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding properties
        scheduledFor = try values.decode(Date.self, forKey: .scheduledFor)
        scheduledDuration = try values.decode(TimeInterval.self, forKey: .scheduledDuration)
        start = try values.decodeIfPresent(Date.self, forKey: .start)
        end = try values.decodeIfPresent(Date.self, forKey: .end)
        let rawState = try values.decode(String.self, forKey: .state)
        guard let state = State(rawValue: rawState) else {
            throw DecodingError.valueNotFound(State.self, DecodingError.Context(codingPath: [CodingKeys.state], debugDescription: "State not found", underlyingError: nil))
        }
        self.state = state
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(scheduledFor, forKey: .scheduledFor)
        try values.encode(scheduledDuration, forKey: .scheduledDuration)
        try values.encode(start, forKey: .start)
        try values.encode(end, forKey: .end)
        try values.encode(state.rawValue, forKey: .state)
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