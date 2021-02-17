//
//  EventRepresentation.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/12/21.
//

import Foundation

struct EventRepresentation: Decodable {
    
    let textEn: String
    let textDe: String
    var startDate: Date? = nil
    var startDouble: Double = 0
    let major: Bool
    var license: String? = nil
    var source: String? = nil
    var image: String? = nil
    
    enum EventKeys: String, CodingKey {
        case text
        case startTime = "unit"
        case major
        case fancy

        enum textKeys: String, CodingKey {
            case textEn = "en"
            case textDe = "de"
        }

        enum fancyKeys: String, CodingKey {
            case license
            case source
            case image
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EventKeys.self)
        
        let textContainer = try container.nestedContainer(keyedBy: EventKeys.textKeys.self, forKey: .text)
        textEn = try textContainer.decode(String.self, forKey: .textEn)
        textDe = try textContainer.decode(String.self, forKey: .textDe)
        
        if let double = try? container.decode(Double.self, forKey: .startTime) {
            startDouble = double
        } else if let string = try? container.decode(String.self, forKey: .startTime) {
            let unitHelper = UnitHelper(unitType: "date")
            startDate = unitHelper.dateFromString(string: string)
            startDouble = startDate?.timeIntervalSince1970 ?? 0
        }
        
        major = try container.decode(Bool.self, forKey: .major)
        
        let fancyContainer = try container.nestedContainer(keyedBy: EventKeys.fancyKeys.self, forKey: .fancy)
        license = try? fancyContainer.decode(String.self, forKey: .license)
        source = try? fancyContainer.decode(String.self, forKey: .source)
        image = try? fancyContainer.decode(String.self, forKey: .image)
    }
    
}
