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
}
