//
//  File.swift
//  Reciplease
//
//  Created by Yoan on 13/05/2022.
//

import Foundation
import CoreData

class FavoritesRecipes: NSManagedObject {
    static var shared = FavoritesRecipes(context: CoreDataManager.shared.mainContext)
    var all: [FavoritesRecipes] {
        let request: NSFetchRequest<FavoritesRecipes> = FavoritesRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        guard let recipes = try? mainContext.fetch(request) else {
            return []
        }
        return recipes
    }
    
    var mainContext: NSManagedObjectContext = CoreDataManager.shared.mainContext
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.mainContext = context ?? CoreDataManager.shared.mainContext
    }
    
    
   static func favoriteRecipeEntities() -> [RecipeDetailsEntity] {
       FavoritesRecipes.shared.all.map {
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
