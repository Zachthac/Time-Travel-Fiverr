//
//  ScenarioRepresentation.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/15/21.
//

import Foundation

struct ScenarioRepresentation: Decodable {
    
    let nameId: String
    let nameEn: String
    let nameDe: String
    let descriptionEn: String
    let descriptionDe: String
    
    let unit: String
    var startDate: Date? = nil
    var startDouble: Double = 0
    var endDate: Date? = nil
    var endDouble: Double = 0
    
    let totalEvents: Int
    let majorEvents: Int

    var license: String? = nil
    var source: String? = nil
    var image: String? = nil
    
    let events: [EventRepresentation]
    
    enum Keys: String, CodingKey {
        case nameId = "name_id"
        case name
        case description

        case unit
        case startTime = "start"
        case endTime = "end"
        
        case majorEvents = "num_major_events"
        case totalEvents = "num_events"
        
        case events
        case fancy
        
        enum nameKeys: String, CodingKey {
            case nameEn = "en"
            case nameDe = "de"
        }
        
        enum descriptionKeys: String, CodingKey {
            case descriptionEn = "en"
            case descriptionDe = "de"
        }
        
        enum fancyKeys: String, CodingKey {
            case license
            case source
            case image
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        nameId = try container.decode(String.self, forKey: .nameId)
        let nameContainer = try container.nestedContainer(keyedBy: Keys.nameKeys.self, forKey: .name)
        nameEn = try nameContainer.decode(String.self, forKey: .nameEn)
        nameDe = try nameContainer.decode(String.self, forKey: .nameDe)
        
        let descriptionContainer = try container.nestedContainer(keyedBy: Keys.descriptionKeys.self, forKey: .description)
        descriptionEn = try descriptionContainer.decode(String.self, forKey: .descriptionEn)
        descriptionDe = try descriptionContainer.decode(String.self, forKey: .descriptionDe)

        let unitString = try container.decode(String.self, forKey: .unit)
        unit = unitString
        
        let unitHelper = UnitHelper(unitType: unit)
        
        if let doubleStart = try? container.decode(Double.self, forKey: .startTime) {
            startDouble = doubleStart
        } else if let stringStart = try? container.decode(String.self, forKey: .startTime) {
            startDate = unitHelper.dateFromString(string: stringStart)
            startDouble = startDate?.timeIntervalSince1970 ?? 0
        }
        
        if let doubleEnd = try? container.decode(Double.self, forKey: .endTime) {
            endDouble = doubleEnd
        } else if let stringEnd = try? container.decode(String.self, forKey: .endTime) {
            endDate = unitHelper.dateFromString(string: stringEnd)
            endDouble = endDate?.timeIntervalSince1970 ?? 0
        }
        
        totalEvents = try container.decode(Int.self, forKey: .totalEvents)
        majorEvents = try container.decode(Int.self, forKey: .majorEvents)
        
        let fancyContainer = try container.nestedContainer(keyedBy: Keys.fancyKeys.self, forKey: .fancy)
        license = try? fancyContainer.decode(String.self, forKey: .license)
        source = try? fancyContainer.decode(String.self, forKey: .source)
        image = try? fancyContainer.decode(String.self, forKey: .image)
        
        events = try container.decode([EventRepresentation].self, forKey: .events)
    }
    
}
