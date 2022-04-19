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

enum ManualMethod: String, Codable, CaseIterable {
    
    case one
    case two
    case three
    case four
    case five
    case andre
    case other
    case unknown
}

