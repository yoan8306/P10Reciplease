//
//  File.swift
//  Reciplease
//
//  Created by Yoan on 13/05/2022.
//

import Foundation
import CoreData

class FavoritesRecipes: NSManagedObject {
    static var all: [FavoritesRecipes] {
        let request: NSFetchRequest<FavoritesRecipes> = FavoritesRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }
    
   static func favoriteRecipeEntities() -> [RecipeDetailsEntity] {
       FavoritesRecipes.all.map {
           RecipeDetailsEntity.init(label: $0.label,
                                    image: $0.image,
                                    url: $0.url,
                                    yield: $0.yield,
                                    ingredientLines: $0.ingredientLines,
                                    totalTime: $0.totalTime,
                                    ingredients: $0.ingredients)
        }
    }
}
