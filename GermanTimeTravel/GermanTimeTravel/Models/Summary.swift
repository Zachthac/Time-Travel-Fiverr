//
//  Summary.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 1/14/21.
//

import Foundation

struct Summary: Decodable {
    let nameId: String
    let nameEn: String
    let nameDe: String
    let descriptionEn: String
    let descriptionDe: String
    let totalEvents: Int
    let majorEvents: Int
    var license: String? = nil
    var source: String? = nil
    var image: String? = nil
    var runtime: Double? = nil
    var suggestionEn: String? = nil
    var suggestionDe: String? = nil
    
    enum Keys: String, CodingKey {
        case nameId = "name_id"
        case name
        case description
        
        case majorEvents = "num_major_events"
        case totalEvents = "num_events"
        case fancy
        case runtime
                
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
        
        enum runtimeKeys: String, CodingKey {
            case recommended
            case text
            
            enum textKeys: String, CodingKey {
                case suggestionEn = "en"
                case suggestionDe = "de"
            }
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
        
        totalEvents = try container.decode(Int.self, forKey: .totalEvents)
        majorEvents = try container.decode(Int.self, forKey: .majorEvents)
        
        let fancyContainer = try container.nestedContainer(keyedBy: Keys.fancyKeys.self, forKey: .fancy)
        license = try? fancyContainer.decode(String.self, forKey: .license)
        source = try? fancyContainer.decode(String.self, forKey: .source)
        image = try? fancyContainer.decode(String.self, forKey: .image)

        let runtimeContainer = try container.nestedContainer(keyedBy: Keys.runtimeKeys.self, forKey: .runtime)
        runtime = try? runtimeContainer.decode(Double.self, forKey: .recommended)
        let textContainer = try runtimeContainer.nestedContainer(keyedBy: Keys.runtimeKeys.textKeys.self, forKey: .text)
        suggestionEn = try? textContainer.decode(String.self, forKey: .suggestionEn)
        suggestionDe = try? textContainer.decode(String.self, forKey: .suggestionDe)
    }
}
