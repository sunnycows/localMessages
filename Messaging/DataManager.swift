//
//  DataManager.swift
//  Messaging
//
//  Created by Oleh Sannikov on 10.06.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit
import CoreData

class DataManager {

    // MARK: Singleton
    private struct Singleton {
        static var instance: DataManager?
        static var token: dispatch_once_t = 0
    }

    class var sharedManager: DataManager {
        dispatch_once(&Singleton.token) {
            Singleton.instance = DataManager()
        }
        return Singleton.instance!
    }

    // MARK: Implementation
    let kPasteboardName = NSBundle.mainBundle().objectForInfoDictionaryKey("pasteboardName") as! String!
    let kGenericUser = NSBundle.mainBundle().objectForInfoDictionaryKey("genericUserId") as! String!
    var buddyName: String?
    
    lazy var pasteboard: UIPasteboard = {
        let result = UIPasteboard(name: self.kPasteboardName, create: true)
        result.persistent = true
        return result
    }()
    
    var pendingMessages: [Message]? {
        if let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("unsent") {
            return self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Message]
        }
        return nil
    }
    
    var messages: [Message]? {
        if let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("all")?.copy() as? NSFetchRequest {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            return self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Message]
        }
        return nil
    }
    
    func receieveMessages() {
    
    }
    
    func sendMessages() {
//        pasteboard
    }
    
    func addMessage(text: String) {
        if let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: self.managedObjectContext) as? Message {
            message.text = text
            message.sent = false
            message.userId = buddyName ?? kGenericUser
            message.date = NSDate().timeIntervalSinceReferenceDate
        }
    }

    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Messaging", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Messaging.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let moc = self.managedObjectContext
        var error: NSError? = nil
        if moc.hasChanges && !moc.save(&error) {
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }

}