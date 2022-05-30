//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Yoan on 19/05/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Properties
    static var shared = CoreDataManager(modelName: "Reciplease")
    var persistentContainer: NSPersistentContainer
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Life cycle
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let unwrappedError = error else { return }
            fatalError("Unresolved error \(unwrappedError.localizedDescription)")
        })
    }

// MARK: - functions
    func recipeAlreadyExist(recipe: RecipeDetailsEntity) -> Bool {
        let recipeList = FavoritesRecipes.favoriteRecipeEntities()
        return recipeList.contains(recipe)
     }

    func saveRecipe(recipe: RecipeDetailsEntity, completion: (Result<Void, Error>) -> Void) {
         let newRecipe = FavoritesRecipes(context: mainContext)
    
         newRecipe.ingredientLines = recipe.ingredientLines
         newRecipe.image = recipe.image
         newRecipe.url = recipe.url
         newRecipe.label = recipe.label
         newRecipe.ingredients = recipe.ingredients?.description
         newRecipe.totalTime = recipe.totalTime ?? 0
         newRecipe.yield = recipe.yield ?? 0

         save(completion)
     }

    func deleteRecipe(recipe: RecipeDetailsEntity, completion: (Result<Void, Error>) -> Void) {
        let recipesList = FavoritesRecipes.favoriteRecipeEntities()
        guard let index = recipesList.firstIndex(where: { $0 == recipe }) else {
            completion(.failure(CoreDataError.deleteError))
            return
        }
       
        mainContext.delete(FavoritesRecipes.shared.all[index])
        save(completion)
     }
    
    func deleteAllRecipes(completion: (Result<Void, Error>) -> Void) {
        for recipe in FavoritesRecipes.shared.all {
             mainContext.delete(recipe)
         }
        save(completion)
     }

// MARK: - private function
    private func save(_ completion: (Result<Void, Error>) -> Void) {
        do {
            try mainContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.deleteError))
        }
    }
}
