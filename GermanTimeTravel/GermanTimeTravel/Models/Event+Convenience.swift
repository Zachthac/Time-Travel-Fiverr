//
//  Event+Convenience.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/12/21.
//

import Foundation
import CoreData

extension Event {
    
    @discardableResult convenience init(textEn: String,
                                        textDe: String,
                                        startDate: Date? = nil,
                                        startDouble: Double = 0,
                                        displayTiming: Double = 0,
                                        displayed: Bool = false,
                                        major: Bool,
                                        license: String? = nil,
                                        source: String? = nil,
                                        image: String? = nil,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.textEn = textEn
        self.textDe = textDe
        self.startDate = startDate
        self.startDouble = startDouble
        self.displayTiming = startDouble
        self.displayed = displayed
        self.major = major
        self.license = license
        self.source = source
        self.image = image
    }
    
    @discardableResult convenience init(eventRepresentation: EventRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(textEn: eventRepresentation.textEn,
                  textDe: eventRepresentation.textDe,
                  startDate: eventRepresentation.startDate,
                  startDouble: eventRepresentation.startDouble,
                  major: eventRepresentation.major,
                  license: eventRepresentation.license,
                  source: eventRepresentation.source,
                  image: eventRepresentation.image,
                  context: context)
    }
    
}
