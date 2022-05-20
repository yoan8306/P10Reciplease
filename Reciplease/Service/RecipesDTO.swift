//
//  RecipesResult.swift
//  Reciplease
//
//  Created by Kel_Jellysh on 06/01/2022.
//

import Foundation
import UIKit
// MARK: Properties to Parse and Get Data
struct RecipesDTO: Decodable {
    var hits: [Recipe]?
}

struct Recipe: Decodable {
    var recipe: RecipeDetails?
}

struct RecipeDetails: Decodable {
    var label: String?
    var image: String?
    var url: String?
    var yield: Double?
    var ingredientLines: [String]?
    var totalTime: Double?
    var ingredients: [IngredientsData]?
    var ingredientsString: String?
    
    mutating func asEntity() -> RecipeDetailsEntity {
        convertIngredientsToString()
       return RecipeDetailsEntity(label: label,
                            image: image,
                            url: url,
                            yield: yield,
                            ingredientLines: ingredientLines,
                            totalTime: totalTime,
                            ingredients: ingredientsString)
    }
    
    mutating func convertIngredientsToString() {
        var arrayIngredients: [String] = []
        guard let ingredients = ingredients else {
            return
        }
        for element in ingredients {
            guard let food = element.food else {
                return
            }
            arrayIngredients.append(food)
        }
        ingredientsString = arrayIngredients.joined(separator: ", ")
    }
}

struct IngredientsData: Decodable {
    var food: String?
}
