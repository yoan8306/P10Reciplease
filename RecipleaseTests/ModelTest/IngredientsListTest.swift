//
//  IngredientsListTest.swift
//  RecipleaseTests
//
//  Created by Yoan on 22/05/2022.
//

import XCTest
@testable import Reciplease

class IngredientsListTest: XCTestCase {
    var myList = ""
    var ingredientList = IngredientsList()
    
    override func setUp() {
        myList = ""
        ingredientList = IngredientsList()
    }
    
    func testGivenAnIngredientsList_WhenWeAddIngredient_ThenlistIngredientContainsListIngredient() {
        myList = "Cheese, lemon, tomatoes"
        
        let verify = ingredientList.addIngredient(ingredientList: myList)
            XCTAssertEqual(["Cheese", "lemon", "tomatoes"], ingredientList.listIngredient)
            XCTAssertTrue(verify)

    }
    
    func testGivenIngredientListEmpty_WhenAddIngredient_ThenAddIngredientReturnFalse() {
        myList = ""
        
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        XCTAssertFalse(verify)
    }
}
