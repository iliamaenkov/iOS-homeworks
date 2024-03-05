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
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    //MARK: Save Post in Background
       
       func savePostInBackground(_ post: Post) {
           backgroundContext.perform { [weak self] in
               guard let self = self else { return }
               
               let postEntity = PostEntity(context: self.backgroundContext)
               postEntity.id = post.id
               postEntity.author = post.author
               postEntity.postText = post.description
               postEntity.image = post.image
               postEntity.likes = Int32(post.likes)
               postEntity.views = Int32(post.views)
               
               self.saveContextInBackground()
           }
       }
       
       //MARK: Check if Post is Saved
       
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

       //MARK: Set Post Liked Status in Background

       func setPostLikedStatus(_ postIndex: Int, isLiked: Bool) {
           backgroundContext.perform { [weak self] in
               guard let self = self else { return }
               
               let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "id == %@", posts[postIndex].id as CVarArg)

               do {
                   let postEntities = try self.backgroundContext.fetch(fetchRequest)
                   if let postEntity = postEntities.first {
                       postEntity.isLiked = isLiked
                       try self.backgroundContext.save()
                   }
               } catch {
                   print("Error updating post liked status: \(error.localizedDescription)")
               }
           }
       }
    
    //MARK: Get posts
    
    func fetchLikedPosts(completion: @escaping ([Post]) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isLiked == true")

            do {
                let postEntities = try self.backgroundContext.fetch(fetchRequest)
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

                completion(likedPosts)
            } catch {
                print("Error fetching liked posts: \(error.localizedDescription)")
                completion([])
            }
        }
    }
       
       //MARK: Delete Post in Background
       
    func deletePostInBackground(_ post: Post, completion: @escaping () -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", post.id as CVarArg)

            do {
                let postEntities = try self.backgroundContext.fetch(fetchRequest)
                for postEntity in postEntities {
                    self.backgroundContext.delete(postEntity)
                }
                self.saveContextInBackground()
                completion()
            } catch {
                print("Error deleting post: \(error.localizedDescription)")
            }
        }
    }


    
    //MARK: Save context
    
    private func saveContextInBackground() {
          do {
              try backgroundContext.save()
          } catch {
              print("Unresolved error saving background context: \(error)")
          }
      }
}



