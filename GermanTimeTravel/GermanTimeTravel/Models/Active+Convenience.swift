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
                                        displayRatio: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.startTime = startTime
        self.totalTime = totalTime
        self.displayRatio = displayRatio
    }
    
    @discardableResult convenience init(totalTime: Double, displayRatio: Double, scenario: Scenario, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(startTime: Date(timeIntervalSinceNow: 4),
                  totalTime: totalTime,
                  displayRatio: displayRatio,
                  context: context)
        
        scenario.active = self
    }
}
