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
    
    func saveRecipe(recipe: RecipeDetails?) -> Bool {
        guard let recipe = recipe else {
            return false
        }

        let newRecipe = FavoritesRecipes(context: AppDelegate.viewContext)
        newRecipe.ingredientLines = recipe.ingredientLines
        newRecipe.image = recipe.image
        newRecipe.url = recipe.url
        newRecipe.label = recipe.label
        newRecipe.ingredients = recipe.ingredients?.description
        newRecipe.totalTime = recipe.totalTime ?? 0
        newRecipe.yield = recipe.yield ?? 0
        newRecipe.imageRecipe = recipe.imageRecipe
        
        do {
            try AppDelegate.viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func deleteRecipe(index: Int) -> String {
        let recipesList = FavoritesRecipes.all
        AppDelegate.viewContext.delete(recipesList[index])
        do {
            try AppDelegate.viewContext.save()
            return "Recipe is delete successful "
        }
        catch {
            return "Error during deleting, \nTry again."
        }
    }
    
    func deleteAllRecipes() -> String {
        for recipe in FavoritesRecipes.all {
            AppDelegate.viewContext.delete(recipe)
        }
        do {
            try AppDelegate.viewContext.save()
           return "You have deletes all 🗑"
        } catch {
          return "An error exist. We don't can remove all, \nTry again."
        }
    }
    
}
