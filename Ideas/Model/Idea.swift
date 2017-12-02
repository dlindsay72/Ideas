//
//  Idea.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation
import CloudKit

struct Idea {
    
    static let recordType = "Idea"
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title
    }
    
    func ideaRecord() -> CKRecord {
        let record = CKRecord(recordType: Idea.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
