//
//  AppDelegate.swift
//  Messaging
//
//  Created by Oleh Sannikov on 10.06.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        DataManager.sharedManager.saveContext()
    }

}

