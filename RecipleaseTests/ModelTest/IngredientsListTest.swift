//
//  IngredientsListTest.swift
//  RecipleaseTests
//
//  Created by Yoan on 22/05/2022.
//

import XCTest
@testable import Reciplease

class IngredientsListTest: XCTestCase {
    // MARK: - properties
    var myList = ""
    var ingredientList = IngredientsList()
    
    // MARK: - Life cycle
    override func setUp() {
        myList = ""
        ingredientList = IngredientsList()
    }
    
    // MARK: - Test
    
    // test if convert ingredient list into array
    func testGivenAnIngredientsList_WhenWeAddIngredient_ThenlistIngredientContainsListIngredient() {
        myList = "Cheese, lemon, tomatoes"
        
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        XCTAssertEqual(["Cheese", "lemon", "tomatoes"], ingredientList.listIngredient)
        XCTAssertTrue(verify)
        
    }
    
    // test if ingredient list is empty
    func testGivenIngredientListEmpty_WhenAddIngredient_ThenAddIngredientReturnFalse() {
        myList = ""
        
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        XCTAssertFalse(verify)
    }
    
    // test if delete one ingredient into array
    func testGivenIngredientList_WhenDeleteOneIngredient_ThenTheIngredientIsRemove() {
        myList = "Cheese, lemon, tomatoes"
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        ingredientList.removeIngredient(index: 1)
        
        XCTAssertTrue(verify)
        XCTAssertEqual(["Cheese", "tomatoes"], ingredientList.listIngredient)
    }
    
    // test clear list ingredient
    func testGivenIngredientList_WhenDeleteAll_ThenTheIngredientListIsClear() {
        myList = "Cheese, lemon, tomatoes"
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        ingredientList.clearListIngredient()
        
        XCTAssertTrue(verify)
        XCTAssertEqual([], ingredientList.listIngredient)
    }
    
    // test convert array to string
    func testGivenIngredientList_WhenReturnIngredientList_ThenIngredientIsConvertToStringWithoutSpace() {
        myList = "Cheese, lemon, tomatoes"
        let verify = ingredientList.addIngredient(ingredientList: myList)
        
        let myString = ingredientList.returnIngredientList()
        
        XCTAssertTrue(verify)
        XCTAssertEqual("Cheese,lemon,tomatoes", myString)
    }
}
