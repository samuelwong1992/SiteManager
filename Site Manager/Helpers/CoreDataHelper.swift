//
//  CoreDataHelper.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit
import CoreData

private var _container: NSPersistentContainer!

struct CoreDataHelper {
    static var container: NSPersistentContainer {
        get {
            if _container != nil {
                return _container
            } else {
                _container = generatePersistentContainer()
                return _container
            }
        }
    }
    
    static var context: NSManagedObjectContext {
        return CoreDataHelper.container.viewContext
    }
    
    static func generatePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "CDModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }
}
