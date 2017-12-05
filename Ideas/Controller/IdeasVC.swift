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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 1, green: 0.5943232126, blue: 0.04868936191, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.3579174876, green: 0.7784708738, blue: 0.997761786, alpha: 0.57)
        cell.textLabel?.textColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        cell.textLabel?.highlightedTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Noteworthy", size: 30)
        cell.selectedBackgroundView? = bgColorView
        
        return cell
    }
}






















