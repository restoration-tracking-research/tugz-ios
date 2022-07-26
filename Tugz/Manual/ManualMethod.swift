//
//  ManualMethods.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 18/04/2022.
//

import Foundation

enum Method: Codable {
    case manual(method: ManualMethod)
    case device(device: Device)
}

enum ManualMethod: String, Codable, CaseIterable, Identifiable {
    
    var id: String { rawValue }
    
    case one
    case two
    case three
    case four
    case five
    case other
    
    func displayName() -> String {
        
        switch self {
        case .one,
                .two,
            .four,
            .five:
            return "Manual Method \(rawValue.capitalized)"
        case .three:
            return "Manual Method Three (Andre's Method)"
        case .other:
            return "Other"
        }
    }
}

