//
//  CDHelper.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 10/05/25.
//

import CoreData
import Foundation

final class CDHelper {
    
    static let shared = CDHelper()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
   
        let container = NSPersistentContainer(name: "Moviebase__Task_MTSL_")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
