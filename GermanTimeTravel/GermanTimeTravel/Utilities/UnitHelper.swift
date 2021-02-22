//
//  UnitHelper.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 2/17/21.
//

import Foundation

enum UnitType: String {
    case time = "datetime"
    case date = "date"
    case astronomical = "ae, miokm, miomiles"
    case distance = "km"
    case other
}

class UnitHelper {
    
    var unitType: UnitType
    var language: Language
    var unit: Unit
    var formatter = DateFormatter()
    
    let kmToMiles = 0.621371192
    let astroToMMiles = 92.955807
    let astroToMKm = 149.597871
    
    init(unitType: String, language: Language = .english, unit: Unit = .imperial) {
        self.unitType = UnitType(rawValue: unitType) ?? .other
        self.language = language
        self.unit = unit
    }
    
    func dateFromString(string: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.date(from: string)
    }
    
    func eventCellLabel(date: Date?, double: Double) -> String {
        switch unitType {
        case .date:
            guard let date = date else { return "date unavailable" }
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter.string(from: date)
        case .time:
            guard let date = date else { return "time unavailable" }
            formatter.dateStyle = .long
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.timeStyle = .medium
            return formatter.string(from: date)
        case .astronomical:
            if unit == .imperial {
                if language == .english {
                    return String("\(Int(double * astroToMMiles)) Million Miles")
                } else {
                    return String("\(Int(double * astroToMMiles)) Millionen Meilen")
                }
            } else {
                if language == .english {
                    return String("\(Int(double * astroToMKm)) Million Kilometers")
                } else {
                    return String("\(Int(double * astroToMKm)) Millionen Kilometer")
                }
            }
        case .distance:
            if unit == .imperial {
                if language == .english {
                    return String("\(Int(double * kmToMiles)) Miles")
                } else {
                    return String("\(Int(double * kmToMiles)) Meilen")
                }
            } else {
                if language == .english {
                    return String("\(Int(double)) Kilometers")
                } else {
                    return String("\(Int(double)) Kilometer")
                }
            }
        case .other:
            return "\(Int(double)) unknown unit type"
        }
    }
    
    func timePassedLabel(double: Double) -> String {
        switch unitType {
        case .date:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: Date(timeIntervalSince1970: double))
        case .time:
            formatter.dateStyle = .none
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.timeStyle = .medium
            return formatter.string(from: Date(timeIntervalSince1970: double))
        case .astronomical:
            if unit == .imperial {
                return String("\(Int(double * astroToMMiles)) M mi")
            } else {
                return String("\(Int(double * astroToMKm)) M km")
            }
        case .distance:
            if unit == .imperial {
                return String("\(Int(double * kmToMiles)) mi")
            } else {
                return String("\(Int(double)) km")
            }
        case .other:
            return String(Int(double))
        }
    }
    
}
