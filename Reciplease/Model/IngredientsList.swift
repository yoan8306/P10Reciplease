//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import Foundation

class IngredientsList {
    var listIngredient: [String]
    
    init() {
        listIngredient = []
    }
    
    func addIngredient(ingredientList: String) {
        let freedSpaceString = ingredientList.filter {!$0.isWhitespace}
        listIngredient.append(contentsOf: freedSpaceString.components(separatedBy: ",") )
    }
}
