//
//  About.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 4/15/21.
//

import Foundation

struct About: Decodable {
    let title: String
    let textEn: String
    let textDe: String
    
    enum Keys: String, CodingKey {
        case text
        case en
        case de
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        title = try container.decode(String.self, forKey: .text)
        textEn = try container.decode(String.self, forKey: .en)
        textDe = try container.decode(String.self, forKey: .de)
    }
}
