//
//  CoreDataService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 27.02.2024.
//

import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Nvigation")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
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
    
    func saveLikedPostIndex(_ index: Int) {
        let context = persistentContainer.viewContext
        let likedPostIndex = LikedPostIndex(context: context)
        likedPostIndex.index = Int64(index)
        saveContext()
    }
    
    func deleteLikedPostIndex(_ index: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPostIndex> = LikedPostIndex.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                saveContext()
            }
        } catch {
            print("Error deleting liked post index: \(error)")
        }
    }
    
    func containsLikedPostIndex(_ index: Int) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPostIndex> = LikedPostIndex.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "index == %d", index)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error fetching liked post index: \(error)")
            return false
        }
    }
    
    func getLikedPostIndexes() -> [Int] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedPostIndex> = LikedPostIndex.fetchRequest()
        
        do {
            let likedPostIndexes = try context.fetch(fetchRequest)
            return likedPostIndexes.map { Int($0.index) }
        } catch {
            print("Error fetching liked post indexes: \(error)")
            return []
        }
    }
}


