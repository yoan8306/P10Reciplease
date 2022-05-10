//
//  RecipesResult.swift
//  Reciplease
//
//  Created by Kel_Jellysh on 06/01/2022.
//

import Foundation
import UIKit
//MARK: Properties to Parse and Get Data
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
}

struct IngredientsData: Decodable {
    var food: String?
}

