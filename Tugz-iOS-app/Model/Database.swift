//
//  Database.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 04/06/2022.
//

import CloudKit

struct Database {
    
    static let container = CKContainer(identifier: "iCloud.Tugz")
    static let publicDb = container.publicCloudDatabase
    static let privateDb = container.privateCloudDatabase
    
    static var userRecordId: CKRecord.ID?
    
    static func getUserRecordId(_ completion: @escaping (CKRecord.ID?)->Void) {
        
        if let userRecordId = userRecordId {
            completion(userRecordId)
            return
        }
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            userRecordId = recordID
            completion(recordID)
        }
    }
}
