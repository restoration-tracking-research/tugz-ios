//
//  Device.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 18/04/2022.
//

import Foundation


enum DeviceCategory: String, Codable, CaseIterable, Identifiable {
    
    var id: ObjectIdentifier { ObjectIdentifier(rawValue as NSString) }
    
    case traditional
    case dual_Tension
    case inflation
    case taping
    case weights
    case DIY
    
    var displayName: String {
        
        switch self {
        case .DIY:
            return rawValue
        default:
            return rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
    
    func devices() -> [Device] {
        Device.allCases.filter { $0.category == self }
    }
}

enum Device: String, Codable, CaseIterable, Identifiable {
    
//    var id: ObjectIdentifier { ObjectIdentifier(rawValue as NSString) }
    var id: String { rawValue }
    
    // Trad
    case TLC_Tugger
    case Foreskinned_Workhorse
    case Foreclip
    
    // Dual Tension
    case CAT_II_Q
    case DILE_Insert
    case DTR
    case FED
    case Foreskinned_Tower
    case TLC_X
    
    // Inflation
    case DTR_with_Direct_Air
    case FIT_v2
    case FIT_v3
    case Foreskinned_Air
    case HyperRestore_Direct_Air
    case TLC_Air
    // Indirect air
    case DTR_with_Indirect_Air
    case HyperRestore_Original
    
    // Taping
    case Canister
    case Reverse_Tape
    case T_tape
    
    // Weights
    case DTR_using_weights
    case Foreskinned_Gravity
    case PUD
    case Stealth_Retainers_Weight_Kits
    case TLC_Hangers

    // DIY
    case DIY
    
    var category: DeviceCategory {
        
        switch self {
        case .TLC_Tugger,
                .Foreskinned_Workhorse,
                .Foreclip:
            return .traditional
            
        case .CAT_II_Q,
                .DILE_Insert,
                .DTR,
                .FED,
                .Foreskinned_Tower,
                .TLC_X:
            return .dual_Tension
            
        case .DTR_with_Direct_Air,
                .FIT_v2,
                .FIT_v3,
                .Foreskinned_Air,
                .HyperRestore_Direct_Air,
                .TLC_Air,
                .DTR_with_Indirect_Air,
                .HyperRestore_Original:
            return .inflation
            
        case .Canister,
                .Reverse_Tape,
                .T_tape:
            return .taping
            
        case .DTR_using_weights,
                .Foreskinned_Gravity,
                .PUD,
                .Stealth_Retainers_Weight_Kits,
                .TLC_Hangers:
            return .weights
            
        case .DIY:
            return .DIY
        }
    }
    
    var displayName: String {
        
        switch self {
        case .DTR,
            .FED,
            .TLC_X,
            .PUD:
            return rawValue.replacingOccurrences(of: "_", with: " ").uppercased()
            
        case .DTR_with_Direct_Air:
            return "DTR with Direct Air"
        case .FIT_v2:
            return "FIT v2"
        case .FIT_v3:
            return "FIT v3"
        case .TLC_Air:
            return "TLC Air"
        case .DTR_with_Indirect_Air:
            return "DTR with Indirect Air"
        case .HyperRestore_Original:
            return "HyperRestore Original"

        case .T_tape:
            return "T-tape"
        case .DTR_using_weights:
            return "DTR with Weights"

        case .DIY:
            return "DIY"
        default:
            return rawValue.replacingOccurrences(of: "_", with: " ")
        }
    }
}
