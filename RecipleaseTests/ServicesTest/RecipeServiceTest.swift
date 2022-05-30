//
//  RecipeServiceTest.swift
//  RecipleaseTests
//
//  Created by Yoan on 19/05/2022.
//

import XCTest
import CoreData
@testable import Reciplease

class RecipeServiceTest: XCTestCase {
    func testGivenCallRecipeService_WhenDataIsCorrect_ThenResultEqualSuccess() {
        let session = SessionTaskMock()
        let recipeService = RecipeService(session: session)
        let response = FakeResponseData()
        session.data = response.recipesCorrectData

        recipeService.getTheRecipes(ingredients: "") { callBack in
            switch callBack {
            case .success(let recipe):
                let firstTitle = try! XCTUnwrap(recipe.hits[0].recipe.label)
                XCTAssertEqual(firstTitle, "Naomi Duguid's Fried Noodles")

            case .failure(_):
                fatalError()
            }
        }
    }

    func testGivenCallRecipeService_WhenDataIsIncorrect_ThenResultEqualFailure() {
        let session = SessionTaskMock()
        let recipeService = RecipeService(session: session)
        let response = FakeResponseData()

        session.data = response.recipesIncorrectData

        recipeService.getTheRecipes(ingredients: "") { callBack in
            switch callBack {
            case .success(_):
                fatalError()
            case .failure(let error):
                XCTAssertEqual(APIError.decoding, error as! APIError)
            }
        }
    }
}
