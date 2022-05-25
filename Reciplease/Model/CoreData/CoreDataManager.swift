//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Yoan on 19/05/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()
    private init() {}

    func recipeAlreadyExist(recipe: RecipeDetailsEntity) -> Bool {
        guard let url = recipe.url else {
             return false
         }

         return FavoritesRecipes.all.contains(where: { recipe in
             recipe.url == url
         })
     }

    func saveRecipe(recipe: RecipeDetailsEntity) -> Bool {
         let newRecipe = FavoritesRecipes(context: AppDelegate.viewContext)
         newRecipe.ingredientLines = recipe.ingredientLines
         newRecipe.image = recipe.image
         newRecipe.url = recipe.url
         newRecipe.label = recipe.label
         newRecipe.ingredients = recipe.ingredients?.description
         newRecipe.totalTime = recipe.totalTime ?? 0
         newRecipe.yield = recipe.yield ?? 0

         do {
             try AppDelegate.viewContext.save()
             return true
         } catch {
             return false
         }
     }
    
    func deleteRecipe(recipe: RecipeDetailsEntity, completion: (Result<Void, Error>) -> Void) {
        let recipesList = FavoritesRecipes.favoriteRecipeEntities()
        guard let index = recipesList.firstIndex(where: { $0 == recipe }) else {
            completion(.failure(CoreDataError.deleteError))
            return
        }

        let recipeToDelete = FavoritesRecipes.all[index]
       
        AppDelegate.viewContext.delete(recipeToDelete)
         do {
             try AppDelegate.viewContext.save()
             completion(.success(()))
         }
         catch {
             completion(.failure(CoreDataError.deleteError))
         }
     }
     
    func deleteAllRecipes(completion: (Result<Void, Error>) -> Void) {
         for recipe in FavoritesRecipes.all {
             AppDelegate.viewContext.delete(recipe)
         }
         do {
             try AppDelegate.viewContext.save()
             completion(.success(()))
         } catch {
             completion(.failure(CoreDataError.deleteError))
        }
     }
}
