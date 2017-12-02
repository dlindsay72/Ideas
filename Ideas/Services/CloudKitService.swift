//
//  CloudKitService.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitService {
    
    private init() {}
    static let shared = CloudKitService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "no ck save error")
            print(record ?? "no ck record saved")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "no ck query error")
            guard let records = records else { return }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    func subscribe() {
        let subsciption = CKQuerySubscription(recordType: Idea.recordType,
                                              predicate: NSPredicate(value: true),
                                              options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subsciption.notificationInfo = notificationInfo
        
        privateDatabase.save(subsciption) { (sub, error) in
            print(error ?? "No ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    func subscribeWithUI() {
        let subsciption = CKQuerySubscription(recordType: Idea.recordType,
                                              predicate: NSPredicate(value: true),
                                              options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.title = "State of Mind"
        notificationInfo.subtitle = "A Whole New iCloud"
        notificationInfo.alertBody = "WE have infiltrated your mind and are documenting your ideas here"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subsciption.notificationInfo = notificationInfo
        
        privateDatabase.save(subsciption) { (sub, error) in
            print(error ?? "No ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    func fetchRecord(with recordId: CKRecordID) {
        privateDatabase.fetch(withRecordID: recordId) { (record, error) in
            print(error ?? "no ck fetch error")
            guard let record = record else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchedRecord"),
                                                object: record)
            }
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification,
                let recordId = queryNotification.recordID
                else { return }
            fetchRecord(with: recordId)
            
        default: return
            
        }
    }
}
