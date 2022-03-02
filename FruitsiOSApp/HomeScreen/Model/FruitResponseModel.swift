//
//  FruitModel.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation

// MARK: - Fruit model raw data

struct FruitResponseModel: Codable {
    var fruits: [FruitInfo]?
    
    enum CodingKeys: String, CodingKey {
        case fruits = "fruit"
    }
}

struct FruitInfo: Codable {
    let type: String
    let price: Int
    let weight:  Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case price = "price"
        case weight = "weight"
    }
}

protocol FruitResponseProtocol:Any {
    var type: String? {get set}
    var price: Int {get set}
    var weight: Int {get set}
}

struct FruitResponse: FruitResponseProtocol {
    var type: String?
    var price: Int
    var weight: Int
}

