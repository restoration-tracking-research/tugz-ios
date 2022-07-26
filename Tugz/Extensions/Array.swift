//
//  Array.swift
//  Tugz
//
//  Created by Charlie Williams on 21/10/2021.
//

import Foundation

/// Kind of a hack; don't use this on empty arrays
extension Array: Identifiable {
    
    public var id: ObjectIdentifier {
        precondition(!self.isEmpty)
        return first as? ObjectIdentifier ?? ObjectIdentifier(first! as AnyObject)
    }
}
