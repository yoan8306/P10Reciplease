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
    static var shared = CoreDataManager()
    static let modelName = "Reciplease"
    static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.modelName, managedObjectModel: CoreDataManager.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved erre \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - functions
    
    func getFavoritesRecipes() -> [FavoritesRecipes] {
        let request: NSFetchRequest<FavoritesRecipes> = FavoritesRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        guard let recipes = try? mainContext.fetch(request) else {
            return []
        }
        return recipes
    }
    
    func recipeAlreadyExist(recipe: RecipeDetailsEntity) -> Bool {
        let coreDataFavorites = getFavoritesRecipes()
        let recipeList = coreDataFavorites.asEntities()
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
        let coreDataFavorites = getFavoritesRecipes()
        let entitiesFavorites = coreDataFavorites.asEntities()
        
        guard let index = entitiesFavorites.firstIndex(where: { $0 == recipe }) else {
            completion(.failure(CoreDataError.deleteError))
            return
        }
        mainContext.delete(coreDataFavorites[index])
        save(completion)
    }
    
    func deleteAllRecipes(completion: (Result<Void, Error>) -> Void) {
        let coreDataFavorites = getFavoritesRecipes()
        for recipe in coreDataFavorites {
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
            completion(.failure(CoreDataError.saveError))
        }
    }
}
