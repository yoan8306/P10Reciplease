//
//  File.swift
//  Reciplease
//
//  Created by Yoan on 13/05/2022.
//

import Foundation
import CoreData

class FavoritesRecipes: NSManagedObject {

}

extension Collection where Element == FavoritesRecipes {
    func asEntities () -> [RecipeDetailsEntity] {
        map {
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
