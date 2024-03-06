//
//  LikedPostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 27.02.2024.
//

import CoreData
import UIKit
import StorageService

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
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Liked Posts"
        view.addSubview(tableView)
        tuneTableView()
        setupContraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserInfo()
        fetchLikedPosts()
        setupUI()
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
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(showSearchAlert))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = clearButton
    }
    
    private func fetchLikedPosts() {
        coreDataService.fetchLikedPosts { [weak self] likedPosts in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.likedPosts = likedPosts
                self.tableView.reloadData()

                print("Saved posts id's:")
                likedPosts.forEach { post in
                    print("\(post.id)")
                }
            }
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
        let alertController = UIAlertController(title: "Search by Author", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter author's name"
        }
        
        let applyAction = UIAlertAction(title: "Apply", style: .default) { [weak self] _ in
            guard let self = self,
                  let authorName = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            else {
                return
            }
            
            if !authorName.isEmpty {
                self.filterPosts(byAuthor: authorName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
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
            cell.textLabel?.text = "Has to be logged in"
            return cell
        }

        if likedPosts.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No posts liked"
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let postToDelete = self.likedPosts[indexPath.row]

            self.coreDataService.deletePostInBackground(postToDelete) {
                DispatchQueue.main.async {
                    self.likedPosts = self.likedPosts.filter { $0.id != postToDelete.id }
                    self.tableView.reloadData()
                }
                
                completionHandler(true)
            }
        }
        deleteAction.backgroundColor = .red

        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false

        return swipeConfig
    }
}
