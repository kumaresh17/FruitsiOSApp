//
//  FruitsiOSAppUITests.swift
//  FruitsiOSAppUITests
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import XCTest

class FruitsList_DetailUITests: XCTestCase {
    
    func test_navigationtitle_cell_exits() {
        
        let app = XCUIApplication()
        app.launch()
        let navTitle =  app.navigationBars["Fruits"].staticTexts["Fruits"]
        XCTAssertTrue(navTitle.exists)
        let appleCell = app.tables.cells.containing(.staticText, identifier:"apple").element
        XCTAssertTrue(appleCell.exists)
    }
    
    func test_when_cell_is_tapped_navigate_to_detailscreen_and_selected_fruit_details_exist() {
        
        let app = XCUIApplication()
        app.launch()
        let appleCell = app.tables.cells.containing(.staticText, identifier:"apple").element
        XCTAssertTrue(appleCell.exists)
      
        appleCell.tap()
        
        let fruitDetailsNavigationBar = app.navigationBars["Fruit details"]
        let fruitLabel = app.staticTexts["apple"]
        let fruitpriceLabel =  app.staticTexts["Price: £1 and 49 pence"]
        let weightLabel =  app.staticTexts["Weight: 0.12 KG (120 grams)"]
        XCTAssertTrue(fruitDetailsNavigationBar.exists)
        XCTAssertTrue(fruitLabel.exists)
        XCTAssertTrue(fruitpriceLabel.exists)
        XCTAssertTrue(weightLabel.exists)
    }
    
    
    func test_when_cell_is_tapped_navigate_to_detailscreen_and_dismiss_detail_screen_to_home_list_screen() {
        
        let app = XCUIApplication()
        app.launch()
        let appleCell =  app.tables.cells.containing(.staticText, identifier:"apple").element
        let fruitLabel = app.staticTexts["apple"]
        let fruitpriceLabel =  app.staticTexts["Price: £1 and 49 pence"]
        let weightLabel =  app.staticTexts["Weight: 0.12 KG (120 grams)"]
        let backNavigationBtn =  app.navigationBars["Fruit details"].buttons["Fruits"]
        let navTitle =  app.navigationBars["Fruits"].staticTexts["Fruits"]
        
        appleCell.tap()
        
        XCTAssertTrue(fruitLabel.exists)
        XCTAssertTrue(fruitpriceLabel.exists)
        XCTAssertTrue(weightLabel.exists)
        XCTAssertFalse(navTitle.exists)
        
        backNavigationBtn.tap()
        
        XCTAssertFalse(fruitpriceLabel.exists)
        XCTAssertFalse(weightLabel.exists)
        XCTAssertTrue(navTitle.exists)
        XCTAssertTrue(appleCell.exists)
    }
    
    func test_activityindicator_Stop_After_the_tablecell_is_visible() {
        
        let app = XCUIApplication()
        app.launch()
       
        let inProgressActivityIndicator = app.tables["In progress"].activityIndicators["In progress"]
        let cell = app.tables.cells.containing(.staticText, identifier:"banana").element
        XCTAssertFalse(inProgressActivityIndicator.exists)
        XCTAssertTrue(cell.exists)

        
    }
    
}



