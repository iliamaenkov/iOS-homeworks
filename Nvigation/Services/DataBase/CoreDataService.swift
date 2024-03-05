//
//  CoreDataService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 27.02.2024.
//

import Foundation
import CoreData
import StorageService

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
    
    //MARK: Save
    
    func savePost(_ post: Post) {
        let context = persistentContainer.viewContext
        let postEntity = PostEntity(context: context)
        postEntity.id = post.id
        postEntity.author = post.author
        postEntity.postText = post.description
        postEntity.image = post.image
        postEntity.likes = Int32(post.likes)
        postEntity.views = Int32(post.views)
        saveContext()
    }
    
    //MARK: Check post saved or not
    
    func isPostSaved(_ post: Post) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", post.id as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking if post is saved: \(error)")
            return false
        }
    }
    
    //MARK: Get saved posts
    
    func fetchLikedPosts() -> [Post] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isLiked == true")
        
        do {
            let postEntities = try context.fetch(fetchRequest)
            let likedPosts: [Post] = postEntities.compactMap { postEntity in
                guard let id = postEntity.id else {
                    print("Error: Found a PostEntity with nil id.")
                    return nil
                }
                
                return Post(id: id,
                            author: postEntity.author ?? "",
                            description: postEntity.postText ?? "",
                            image: postEntity.image ?? "",
                            likes: Int(postEntity.likes),
                            views: Int(postEntity.views))
            }
            return likedPosts
        } catch {
            print("Error fetching liked posts: \(error.localizedDescription)")
            return []
        }
    }

    
    //MARK: Set post status
    
    func setPostLikedStatus(_ postIndex: Int, isLiked: Bool) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", posts[postIndex].id as CVarArg)

        do {
            let postEntities = try context.fetch(fetchRequest)
            if let postEntity = postEntities.first {
                postEntity.isLiked = isLiked
                try context.save()
            }
        } catch {
            print("Error updating post liked status: \(error.localizedDescription)")
        }
    }
    
    //MARK: Delete post
    
    func deletePost(_ post: Post) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", post.id as CVarArg)

        do {
            let postEntities = try context.fetch(fetchRequest)
            for postEntity in postEntities {
                context.delete(postEntity)
            }
            saveContext()
        } catch {
            print("Error deleting post: \(error.localizedDescription)")
        }
    }
    
    //MARK: Save context
    
    private func saveContext() {
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



