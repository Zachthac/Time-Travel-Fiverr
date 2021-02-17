//
//  Bearer.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/7/20.
//

import Foundation

struct Bearer: Codable {
    var access_token: String
    var token_type: String
    var date: Date
    
    enum Keys: String, CodingKey {
        case access_token
        case token_type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        access_token = try container.decode(String.self, forKey: .access_token)
        token_type = try container.decode(String.self, forKey: .token_type)
        date = Date()
    }
}
