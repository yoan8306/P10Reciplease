//
//  MockCoreDataManager.swift
//  RecipleaseTests
//
//  Created by Yoan on 24/05/2022.
//

import Foundation
import CoreData
@testable import Reciplease

final class MockCoreDataStack: CoreDataManager {
    
    convenience init() {
        self.init(modelName: "Reciplease")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: modelName)

        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { storeDescription, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        self.persistentContainer = container
      }
}
