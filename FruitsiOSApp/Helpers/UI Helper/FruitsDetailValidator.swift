//
//  FruitsDetailValidator.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation

struct FruitsDetailValidator {
    
    func getFruitname(_ response:FruitResponseProtocol?) throws -> String {

        guard let fruitName = response?.type else {throw FruitsDetailParameterValidation.inValidFruitType}
        return fruitName
    }
    
    func getWeightInKg(_ response:FruitResponseProtocol?) throws -> String {
       
        guard let weight = response?.weight else {throw FruitsDetailParameterValidation.inValidWeight}
        guard weight != 0 else { throw FruitsDetailParameterValidation.weightIsZero}
        
        let weightInKg: Double = Double(weight) / 1000
        return "Weight: " + weightInKg.string + " KG " + "(" + weight.string + " grams)"
    }
    
    func getPrice(_ response:FruitResponseProtocol?) throws -> String {
       
        guard let price = response?.price else {throw FruitsDetailParameterValidation.inValidPrice}
        guard price != 0 else { throw FruitsDetailParameterValidation.priceIsZero}
        
       // calculate price in pound and pence
        var priceinPound:Int = 0
        var priceinPence:Int = 0
        
        if (price > 99) { priceinPound = price / 100}
        priceinPence = price % 100
        var priceForUi  = "Price: "
        if (priceinPound > 0) {priceForUi = priceForUi + "£" + priceinPound.string + " and " + priceinPence.string + " pence"
        } else {priceForUi = priceForUi + priceinPence.string + " pence"}
        
        return priceForUi
    }
}


enum FruitsDetailParameterValidation:LocalizedError {
    case inValidFruitType
    case inValidWeight
    case inValidPrice
    case weightIsZero
    case priceIsZero
    
    var errorDescription :String? {
        switch self {
        case .inValidFruitType:
            return "Invalid fruit type response null"
        case .inValidWeight:
            return "Invalid fruit weight response null"
        case .inValidPrice:
            return "Invalid fruit price response null"
        case .weightIsZero:
            return "Fruit Weight is zero"
        case .priceIsZero:
            return "Fruit Price is zero"
        }
    }
}
