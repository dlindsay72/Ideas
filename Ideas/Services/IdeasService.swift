//
//  IdeasService.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation

class IdeasService {
    
    private init() {}
    
    static func getIdeas(completion: @escaping ([Idea]) -> Void) {
        CloudKitService.shared.query(recordType: Idea.recordType) { (records) in
            var ideas = [Idea]()
            for record in records {
                guard let idea = Idea(record: record) else { continue }
                ideas.append(idea)
            }
            completion(ideas)
        }
    }
    
}
