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
    // modify persistantContainer memory type
    override init() {
        super.init()
        let persistentStoreDescription = NSPersistentStoreDescription()
        // modify type of data base
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: CoreDataManager.modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
