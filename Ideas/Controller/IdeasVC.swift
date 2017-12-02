//
//  IdeasVC.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import CloudKit

class IdeasVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ideas = [Idea]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        CloudKitService.shared.subscribeWithUI()
        UserNotificationService.shared.authorize()
        getIdeas()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetch(_:)), name: NSNotification.Name("internalNotification.fetchedRecord"), object: nil)
        
    }
    
    func getIdeas() {
        IdeasService.getIdeas { (ideas) in
            self.ideas = ideas
            self.tableView.reloadData()
        }
    }
    
    func insert(idea: Idea) {
        ideas.insert(idea, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func handleFetch(_ sender: Notification) {
        guard let record = sender.object as? CKRecord, let idea = Idea(record: record) else { return }
        insert(idea: idea)
    }

    @IBAction func composeBtnWasPressed(_ sender: Any) {
        AlertService.composeIdea(in: self) { (idea) in
            CloudKitService.shared.save(record: idea.ideaRecord())
            self.insert(idea: idea)
        }
    }
}

extension IdeasVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let idea = ideas[indexPath.row]
        cell.textLabel?.text = idea.title
        return cell
    }
}






















