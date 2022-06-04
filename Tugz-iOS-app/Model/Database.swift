//
//  Database.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/06/2022.
//

import CloudKit

struct Database {
    
    static let container = CKContainer.default()
    static let publicDb = container.publicCloudDatabase
    static let privateDb = container.privateCloudDatabase
    
    
}
