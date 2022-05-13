//
//  File.swift
//  Reciplease
//
//  Created by Yoan on 13/05/2022.
//

import Foundation
import CoreData

class FavoritesRecipes:NSManagedObject {
    static var all: [FavoritesRecipes] {
        let request: NSFetchRequest<FavoritesRecipes> = FavoritesRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }
    
    func recipeAlreadyExist(url: String?) -> Bool {
        guard let url = url else {
            return false
        }

        if FavoritesRecipes.all.contains(where: { recipe in
            recipe.url == url
        }) {
            return true
        } else {
            return false
        }
    }
}
