//
//  CoreDataTest.swift
//  RecipleaseTests
//
//  Created by Yoan on 30/05/2022.
//

import XCTest
@testable import Reciplease
import CoreData

class CoreDataTest: XCTestCase {
    var recipe1 = RecipeDetailsEntity()
    var recipe2 = RecipeDetailsEntity()
    var recipe3 = RecipeDetailsEntity()
    var myRecipes: [RecipeDetailsEntity] = []
    var coreDataSource = MockCoreDataManager()

    override func setUp() {
        super .setUp()
        createRecipes()
        coreDataSource = MockCoreDataManager()
    }

    func testGivenFavoritesRecipesEqualZeroRecipe_WhenAddOneRecipeIntoFavorite_ThenOneRecipeIsSave() {
        coreDataSource.saveRecipe(recipe: recipe1) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(coreDataSource.getFavoritesRecipes()[0].label, recipe1.label)
            case .failure(_):
                fatalError()
            }
        }
    }

    func testGivenFavoritesRecipesIsEmpty_WhenAddAllRecipes_ThenFavoritesRecipesAreThreeRecipes() {
        saveAllRecipes()

        XCTAssertEqual(coreDataSource.getFavoritesRecipes().count, 3)
        XCTAssertEqual(coreDataSource.getFavoritesRecipes()[0].label, recipe1.label)
        XCTAssertEqual(coreDataSource.getFavoritesRecipes()[1].url, recipe2.url)
        XCTAssertEqual(coreDataSource.getFavoritesRecipes()[2].ingredients, recipe3.ingredients)
    }

    func testGivenThreeRecipesInsideFavorite_WhenDeleteAllRecipes_ThenFavortitesRecipesIsEmpty() {
        saveAllRecipes()

        coreDataSource.deleteAllRecipes { result in
            switch result {
            case .success(_):
                XCTAssertEqual(coreDataSource.getFavoritesRecipes().count, 0)
            case .failure(_):
                fatalError()
            }
        }
    }

    func testGivenAllRecipesAreInFavoritesRecipes_WhenCheckAlreadyExist_ThenResultEqualTrue() {
        saveAllRecipes()

        let result = coreDataSource.recipeAlreadyExist(recipe: recipe1)

        XCTAssertTrue(result)
    }

    func testGivenThreeRecipesInFavorites_WhenDeleteOneRecipe_ThenTheyTwoRecipesInFavorites() {
        saveAllRecipes()

        coreDataSource.deleteRecipe(recipe: recipe3) { result in
            switch result {
            case .success(_):
               let numberFavorites = coreDataSource.getFavoritesRecipes().count
                XCTAssertEqual(numberFavorites, 2)
            case .failure(_):
                fatalError()
            }
        }
    }

    func testGivenNoRecipeInFavorites_WhenDeleteRecipeInFavorite_ThenHavingMessage() {
        coreDataSource.deleteRecipe(recipe: recipe3) { result in
            switch result {
            case .success(_):
                fatalError()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, CoreDataError.deleteError.localizedDescription)
            }
        }
    }

    private func saveAllRecipes() {
        coreDataSource.saveRecipe(recipe: recipe1) { result in
            switch result {
            case .success(_):
                print("Recipe1 save")
            case .failure(let error):
                print("-------\(error.localizedDescription)-------")
                fatalError()
            }
        }

        coreDataSource.saveRecipe(recipe: recipe2) { result in
            switch result {
            case .success(_):
                print("Recipe1 save")
            case .failure(_):
                fatalError()
            }
        }

        coreDataSource.saveRecipe(recipe: recipe3) { result in
            switch result {
            case .success(_):
                print("Recipe1 save")
            case .failure(_):
                fatalError()
            }
        }

        do {
           try coreDataSource.mainContext.save()
        } catch {
            print(CoreDataError.saveError)
        }
    }

   private func createRecipes() {
        recipe1.ingredientLines = ["1 cup dried egg noodles", "Peanut oil, for frying"]
        recipe1.image = "https://www.edamam.com/food-img/800/800c9c0d7cef6b5474723682ffa2878d.jpg"
        recipe1.url = "http://www.edamam.com/ontologies/edamam.owl#recipe_bbfc1a248bd6fe277e35fe01027de91f"
        recipe1.label = "Naomi Duguid's Fried Noodles"
        recipe1.ingredients = "pomegranate juice"
        recipe1.totalTime = 0
        recipe1.yield = 0

        recipe2.ingredientLines = ["8 cups halved strawberries", "1/4 – 1/3 cup sugar", "1 vanilla bean, split and seeds removed"]
        recipe2.image = "https://edamam-product-images.s3.amazonaws.com"
        recipe2.url = "http://www.edamam.com/ontologies/edamam.owl#recipe_51b79ae0958c33a38c0eabad15460917"
        recipe2.label = "Roasted Strawberry Milkshake recipes"
        recipe2.ingredients = "8 cups halved strawberries"
        recipe2.totalTime = 0
        recipe2.yield = 0

       recipe3.ingredientLines = ["Good vanilla ice cream (about 1/2 cup per person, or as you wish)", "Grilled corn (1/2 ear per person)", "1 lime (for every four servings)"]
       recipe3.image = "https://edamam-product-images.s3.amazonaws.com"
       recipe3.url = "http://www.edamam.com/ontologies/edamam.owl#recipe_845a9adf81bb22f3b76ead2981a872a0"
       recipe3.label = "Vanilla Ice Cream With Grilled Corn And Lime"
       recipe3.ingredients = "Good vanilla ice cream (about 1/2 cup per person, or as you wish)"
       recipe3.totalTime = 0
       recipe3.yield = 0

        myRecipes = [recipe1, recipe2, recipe3]
    }
}
