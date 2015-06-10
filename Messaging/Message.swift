//
//  Message.swift
//  Messaging
//
//  Created by Oleh Sannikov on 10.06.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var date: NSTimeInterval
    @NSManaged var text: String
    @NSManaged var userId: String
    @NSManaged var sent: Bool

}
