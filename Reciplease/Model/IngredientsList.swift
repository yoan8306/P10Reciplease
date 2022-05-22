//
//  IngredientsList.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import Foundation

class IngredientsList {
    var listIngredient: [String]
    var punctuation = Punctuation.allCases

    init() {
        listIngredient = []
    }

// MARK: - Add ingredient
    func addIngredient(ingredientList: String) -> Bool {
        let myList = deleteSpace(ingredientList: ingredientList)
        guard !myList.isEmpty else {
            return false
        }
        listIngredient.append(contentsOf: myList.components(separatedBy: ","))
        return true
    }

    private func deleteSpace(ingredientList: String) -> String {
        let freedSpaceString = ingredientList.filter {!$0.isWhitespace}
        return freedSpaceString
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
        return listIngredient.joined(separator: ",")
    }
}
