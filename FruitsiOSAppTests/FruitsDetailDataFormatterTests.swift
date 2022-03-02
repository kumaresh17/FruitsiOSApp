//
//  FruitsAppDetailTests.swift
//  FruitsiOSAppTests
//
//  Created by kumaresh shrivastava on 01/03/2022.
//

import XCTest
@testable import FruitsiOSApp

class FruitsDetailDataFormatterTests: XCTestCase {
    
    
    var validator: FruitsDetailDataFormatter!
    var fruitTestObj:FruitResponseProtocol?

    
    override func setUp() {
        super.setUp()
        validator = FruitsDetailDataFormatter()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
    
    func testisFruitName() throws {
        fruitTestObj = FruitResponse(type: "banana", price: 10, weight: 100)
       XCTAssertNoThrow(try validator.getFruitname(fruitTestObj))
    }
    
    func testFruitName_is_Not_Nill() throws {
        
        let expectedError = FruitsDetailParameterValidation.inValidFruitType
        var error: FruitsDetailParameterValidation?
        XCTAssertThrowsError(try validator.getFruitname(nil)) { thrownError in
            error  = thrownError as? FruitsDetailParameterValidation
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, error?.localizedDescription)
        
    }
    
    func testFruitWeight_is_Not_Nill() throws {
        
        let expectedError = FruitsDetailParameterValidation.inValidWeight
        var error: FruitsDetailParameterValidation?
        XCTAssertThrowsError(try validator.getWeightInKg(nil)) { thrownError in
            error  = thrownError as? FruitsDetailParameterValidation
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, error?.localizedDescription)
        
    }
    
    func testFruitPrice_is_Not_Nill() throws {
        
        let expectedError = FruitsDetailParameterValidation.inValidPrice
        var error: FruitsDetailParameterValidation?
        XCTAssertThrowsError(try validator.getPrice(nil)) { thrownError in
            error  = thrownError as? FruitsDetailParameterValidation
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, error?.localizedDescription)
        
    }
    
    
    func testFruit_Weight_Price_is_Not_Zero() throws {
        
        fruitTestObj = FruitResponse(type: "banana", price: 0, weight: 0)
        let expectedError = FruitsDetailParameterValidation.weightIsZero
        var error: FruitsDetailParameterValidation?
        XCTAssertThrowsError(try validator.getWeightInKg(fruitTestObj)) { thrownError in
            error  = thrownError as? FruitsDetailParameterValidation
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.localizedDescription, error?.localizedDescription)
        
        
        let expectePriceError = FruitsDetailParameterValidation.priceIsZero
        var errorPriceZero: FruitsDetailParameterValidation?
        XCTAssertThrowsError(try validator.getPrice(fruitTestObj)) { thrownError in
            errorPriceZero  = thrownError as? FruitsDetailParameterValidation
        }
        XCTAssertEqual(expectePriceError, errorPriceZero)
        XCTAssertEqual(expectePriceError.localizedDescription, errorPriceZero?.localizedDescription)
        
    }
    
    func testFruit_Price_pound_pence() throws  {
        fruitTestObj = FruitResponse(type: "banana", price: 599, weight: 100)
        let priceLabel = "Price: £5 and 99 pence"
        var fruitUilabel = ""
        XCTAssertNoThrow(fruitUilabel = try validator.getPrice(fruitTestObj))
        XCTAssertEqual(fruitUilabel, priceLabel)
    }
    
    func testFruit_Price__pence() throws  {
        fruitTestObj = FruitResponse(type: "banana", price: 99, weight: 100)
        let priceLabel = "Price: 99 pence"
        var fruitUilabel = ""
        XCTAssertNoThrow(fruitUilabel = try validator.getPrice(fruitTestObj))
        XCTAssertEqual(fruitUilabel, priceLabel)
    }
    
    func testFruit_Weight_pound_pence() throws  {
        fruitTestObj = FruitResponse(type: "banana", price: 599, weight: 100)
        let weightLabel = "Weight: 0.1 KG (100 grams)"
        var fruitUilabel = ""
        XCTAssertNoThrow(fruitUilabel = try validator.getWeightInKg(fruitTestObj))
        XCTAssertEqual(fruitUilabel, weightLabel)
    }
  
//    func test_ValidateAndShow () {
//       // let storyboard = UIStoryboard.storyboard(storyboard: .Main)
//        
//        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
//        let fruitsDetail: FruitsDetailViewController = storyboard.instantiateVieController()
//        XCTAssertNotNil(fruitsDetail)
//        let priceLabel = "Price: £5 and 99 pence"
//        let weightLabel = "Weight: 0.1 KG (100 grams)"
//        fruitTestObj = FruitResponse(type: "banana", price: 599, weight: 100)
//        fruitsDetail.response = fruitTestObj
//        fruitsDetail.detailValidator = FruitsDetailValidator()
//        fruitsDetail.validateAndShowFruitDetails()
//        XCTAssertEqual(fruitsDetail.fruit, "banana")
//        XCTAssertEqual(fruitsDetail.price, priceLabel)
//        XCTAssertEqual(fruitsDetail.weight, weightLabel)
//    }

}





