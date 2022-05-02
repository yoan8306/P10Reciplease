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

// MARK: - Add ingredient
    func addIngredient(ingredientList: String) -> Bool {
        let myList = deleteSpace(ingredientList: ingredientList)
        guard checkListIngredient(freedSpaceString: myList) else {
            return false
        }
        listIngredient.append(contentsOf: myList.components(separatedBy: ",") )
        return true
    }
    
    private func deleteSpace(ingredientList: String) -> String {
        let freedSpaceString = ingredientList.filter {!$0.isWhitespace}
        return freedSpaceString
    }
    
   private func checkListIngredient(freedSpaceString: String) -> Bool {
       guard !freedSpaceString.isEmpty else {
           return false
       }
       return true
    }
    
// MARK: - delete ingredient
    func clearListIngredient() {
        listIngredient.removeAll()
    }

    func removeIngredient(index: Int) {
        listIngredient.remove(at: index)
    }

// MARK: - return ingredient list
    func returnIngredientList() -> String {
        return listIngredient.joined(separator: ", ")
    }
}
