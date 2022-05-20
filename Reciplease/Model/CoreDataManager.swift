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
     
    func deleteRecipe(recipe url: String?, completion: (Result<Void, Error>) -> Void) {
         let recipesList = FavoritesRecipes.all
        guard let url = url, let index = recipesList.firstIndex(where: {$0.url == url}) else {
            completion(.failure(CoreDataError.deleteError))
            return
        }
       
        AppDelegate.viewContext.delete(recipesList[index])
         do {
             try AppDelegate.viewContext.save()
             completion(.success(()))
         }
         catch {
             completion(.failure(CoreDataError.deleteError))
         }
     }
     
    func deleteAllRecipes() {
         for recipe in FavoritesRecipes.all {
             AppDelegate.viewContext.delete(recipe)
         }
         do {
             try AppDelegate.viewContext.save()
//            return "You have deletes all 🗑"
         } catch {
//           return "An error exist. We don't can remove all, \nTry again."
         }
     }
}
