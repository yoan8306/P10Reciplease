//
//  RecipesResult.swift
//  Reciplease
//
//  Created by Kel_Jellysh on 06/01/2022.
//

import Foundation
import UIKit

struct RecipesDTO: Decodable {
    var hits: [Recipe]
    func asEntities() -> [RecipeDetailsEntity] {
        hits.map { recipe in
            recipe.recipe.asEntity()
        }
    }
}

struct Recipe: Decodable {
    var recipe: RecipeDetails
}

struct RecipeDetails: Decodable {
    var label: String?
    var image: String?
    var url: String?
    var yield: Double?
    var ingredientLines: [String]? // ingredients + quantity
    var totalTime: Double?
    var ingredients: [IngredientsData]? // list ingredients
    var ingredientsString: String?
    
    func asEntity() -> RecipeDetailsEntity {
        RecipeDetailsEntity(label: label,
                                   image: image,
                                   url: url,
                                   yield: yield,
                                   ingredientLines: ingredientLines,
                                   totalTime: totalTime,
                                   ingredients: convertIngredientsToString())
    }
    
   private func convertIngredientsToString() -> String? {
        var arrayIngredients: [String] = []
        guard let ingredients = ingredients else {
            return nil
        }
        for element in ingredients {
            guard let food = element.food else {
                continue
            }
            arrayIngredients.append(food)
        }
        return arrayIngredients.joined(separator: ", ")
    }
}

struct IngredientsData: Decodable {
    var food: String?
}
