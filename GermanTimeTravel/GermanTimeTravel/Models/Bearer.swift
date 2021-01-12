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
}
