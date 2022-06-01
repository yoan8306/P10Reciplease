//
//  MockCoreDataManager.swift
//  RecipleaseTests
//
//  Created by Yoan on 24/05/2022.
//

import Foundation
import CoreData
@testable import Reciplease

final class MockCoreDataManager: CoreDataManager {

    override init() {
        super.init()
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: CoreDataManager.modelName)

        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { storeDescription, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        self.persistentContainer = container
      }
}
