//
//  Recipes.swift
//  Reciplease
//
//  Created by Yoan on 15/05/2022.
//

import Foundation

struct RecipeDetailsEntity {
        var label: String?
        var image: String?
        var url: String?
        var yield: Double?
        var ingredientLines: [String]?
        var totalTime: Double?
        var ingredients: String?
}

extension RecipeDetailsEntity: Equatable {
    static func == (lhs: RecipeDetailsEntity, rhs: RecipeDetailsEntity) -> Bool {
       lhs.url == rhs.url && lhs.label == rhs.label && lhs.ingredients == rhs.ingredients
    }
}
