//
//  Activity.swift
//  juryoku
//
//  Created by Joshua Book on 7/9/15.
//  Copyright (c) 2015 Boovius Projects. All rights reserved.
//

import Foundation
import CoreData

class Activity: NSManagedObject {
    
    @NSManaged var activity: String
    @NSManaged var doneLastAt: NSDate
    @NSManaged var doings: NSSet
    
    func weekly() -> Int {
        var weeklies = 0
        let allDoings = doings.allObjects
        for var index = 0; index < allDoings.count; ++index {
            let doing = allDoings[index] as! Doing
            if DateProcessor.inThisWeek(doing.createdAt) {
                weeklies += 1
            }
        }
        return weeklies
    }
}