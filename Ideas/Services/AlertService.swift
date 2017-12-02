//
//  AlertService.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func composeIdea(in vc: UIViewController, completion: @escaping (Idea) -> Void) {
        let alert = UIAlertController(title: "New Idea", message: "What's on your mind?", preferredStyle: .alert)
        alert.addTextField { (titleTF) in
            titleTF.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            let idea = Idea(title: title)
            completion(idea)
        }
        alert.addAction(post)
        vc.present(alert, animated: true)
    }
    
}
