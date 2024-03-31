//
//  LikedPostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 27.02.2024.
//

import CoreData
import UIKit
import StorageService

extension PostEntity {
    func toPost() -> Post? {
        guard let id = self.id,
              let author = self.author,
              let description = self.postText,
              let image = self.image 
        else {
            return nil
        }

        return Post(id: id,
                    author: author,
                    description: description,
                    image: image,
                    likes: Int(self.likes),
                    views: Int(self.views))
    }
}

extension LikedPostsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            self.likedPosts.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
}

final class LikedPostsViewController:UIViewController {
    
    //MARK:  Properties
    
    var profileViewModel: ProfileViewModel

    private var bAuth: Bool = false
    private var likedPosts: [Post] = []
    private let coreDataService = CoreDataService.shared
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<PostEntity> = {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLiked == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataService.shared.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Liked posts", comment: "Понравившиеся посты")
        view.addSubview(tableView)
        tuneTableView()
        setupContraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.loadUserInfo()
            self.fetchLikedPosts()
            self.setupUI()
        }
    }

    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    
    private func setupUI() {
        let searchButton = UIBarButtonItem(title: NSLocalizedString("Search", comment: "Поиск"), style: .plain, target: self, action: #selector(showSearchAlert))
        let clearButton = UIBarButtonItem(title: NSLocalizedString("Clear", comment: "Очистить"), style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = lightDark
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.leftBarButtonItem?.tintColor = lightDark
    }
    
    private func fetchLikedPosts() {
        do {
            try fetchedResultsController.performFetch()
            if let postEntities = fetchedResultsController.fetchedObjects {
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

                self.likedPosts = likedPosts
                tableView.reloadData()
            }
        } catch {
            print("Error fetching liked posts: \(error.localizedDescription)")
        }
    }

    
    private func loadUserInfo() {
        bAuth = profileViewModel.currentUser != nil
        tableView.reloadData()
    }
    
    private func tuneTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupContraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func showSearchAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Search by Author", comment: "Искать по автору"), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Enter author's name", comment: "Введите имя автора")
        }
        
        let applyAction = UIAlertAction(title: NSLocalizedString("Apply", comment: "Применить"), style: .default) { [weak self] _ in
            guard let self = self,
                  let authorName = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return
            }
            
            if !authorName.isEmpty {
                self.filterPosts(byAuthor: authorName)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Отмена"), style: .cancel, handler: nil)
        
        alertController.addAction(applyAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func filterPosts(byAuthor author: String) {
        let filteredPosts = likedPosts.filter { $0.author.lowercased() == author.lowercased() }
        self.likedPosts = filteredPosts
        self.tableView.reloadData()
    }
    
    @objc private func clearFilter() {
        fetchLikedPosts()
    }
}
    //MARK: Extensions

extension LikedPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bAuth ? max(likedPosts.count, 1) : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !bAuth {
            let cell = UITableViewCell()
            cell.textLabel?.text = NSLocalizedString("Has to be logged in", comment: "Необходимо авторизироваться")
            return cell
        }

        if likedPosts.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = NSLocalizedString("No posts liked", comment: "Нет понравившихся постов")
            return cell
        }

        let post = likedPosts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Can't find a cell")
        }

        cell.setup(with: post)
        return cell
    }
}


extension LikedPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Удалить")) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let postEntityToDelete = self.fetchedResultsController.object(at: indexPath)
            
            if let postToDelete = postEntityToDelete.toPost() {
                self.coreDataService.deletePostInBackground(postToDelete) {
                    completionHandler(true)
                }
            }
        }
        deleteAction.backgroundColor = UIColor.red
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
}
