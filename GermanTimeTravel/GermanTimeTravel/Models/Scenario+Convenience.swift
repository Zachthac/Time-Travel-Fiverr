//
//  Scenario+Convenience.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/12/21.
//

import Foundation
import CoreData

extension Scenario {
    
    @discardableResult convenience init(nameId: String,
                                        nameEn: String,
                                        nameDe: String,
                                        descriptionEn: String,
                                        descriptionDe: String,
                                        unit: String,
                                        startDate: Date? = nil,
                                        startDouble: Double = 0,
                                        endDate: Date? = nil,
                                        endDouble: Double = 0,
                                        totalEvents: Int,
                                        majorEvents: Int,
                                        license: String? = nil,
                                        source: String? = nil,
                                        image: String? = nil,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nameId = nameId
        self.nameEn = nameEn
        self.nameDe = nameDe
        self.descriptionEn = descriptionEn
        self.descriptionDe = descriptionDe
        self.unit = unit
        self.startDate = startDate
        self.startDouble = startDouble
        self.endDate = endDate
        self.endDouble = endDouble
        self.totalEvents = Int16(totalEvents)
        self.majorEvents = Int16(majorEvents)
        self.license = license
        self.source = source
        self.image = image
    }
    
    @discardableResult convenience init(scenarioRepresentation: ScenarioRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(nameId: scenarioRepresentation.nameId,
                  nameEn: scenarioRepresentation.nameEn,
                  nameDe: scenarioRepresentation.nameDe,
                  descriptionEn: scenarioRepresentation.descriptionEn,
                  descriptionDe: scenarioRepresentation.descriptionDe,
                  unit: scenarioRepresentation.unit,
                  startDate: scenarioRepresentation.startDate,
                  startDouble: scenarioRepresentation.startDouble,
                  endDate: scenarioRepresentation.endDate,
                  endDouble: scenarioRepresentation.endDouble,
                  totalEvents: scenarioRepresentation.totalEvents,
                  majorEvents: scenarioRepresentation.majorEvents,
                  license: scenarioRepresentation.license,
                  source: scenarioRepresentation.source,
                  image: scenarioRepresentation.image,
                  context: context)
        
        for event in scenarioRepresentation.events {
            let newEvent = Event(eventRepresentation: event, context: context)
            addToEvents(newEvent)
        }
    }
    
}
