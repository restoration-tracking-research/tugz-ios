//
//  Photo.swift
//  Tugz
//
//  Created by Charlie Williams on 18/04/2022.
//

import UIKit
import CloudKit

final class Photo: Identifiable {
    
    var id: CKRecord.ID
    var image: UIImage?
    var date: Date?
    var url: URL?
    
    init(image: UIImage, date: Date = Date()) {
        self.image = image
        self.date = date
        id = CKRecord.ID()
    }
    
    init(url: URL) {
        self.url = url
        id = CKRecord.ID()
        
        load() { _ in }
    }
    
    func load(completion: @escaping ((Result<Bool, Error>) -> ())) {
        
    }
    
    func save(completion: @escaping ((Result<Bool, Error>) -> ())) {
        
        
    }
}
