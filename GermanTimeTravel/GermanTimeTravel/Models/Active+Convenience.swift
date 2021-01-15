//
//  Active+Convenience.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/14/21.
//

import Foundation
import CoreData

extension Active {
    @discardableResult convenience init(startTime: Date,
                                        totalTime: Double,
                                        lastEventSeen: Int,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.startTime = startTime
        self.totalTime = totalTime
        self.lastEventSeen = Int16(lastEventSeen)
    }
    
    @discardableResult convenience init(totalTime: Double, scenario: Scenario, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(startTime: Date(),
                  totalTime: totalTime,
                  lastEventSeen: 0,
                  context: context)
        
        scenario.active = self
    }
}
