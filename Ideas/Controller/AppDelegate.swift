//
//  AppDelegate.swift
//  Ideas
//
//  Created by Dan Lindsay on 2017-12-01.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification")
        CloudKitService.shared.handleNotification(with: userInfo)
        completionHandler(.newData)
    }


}

