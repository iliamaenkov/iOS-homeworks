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
    var likedPostIndexes: [Int] {
        return coreDataService.getLikedPostIndexes()
    }
    
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
    }
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    
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
}
    //MARK: Extensions

extension LikedPostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bAuth ? max(likedPostIndexes.count, 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !bAuth {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Has to be logged in"
            return cell
        }

        if likedPostIndexes.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No posts liked"
            return cell
        }

        let postIndex = likedPostIndexes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Can't find a cell")
        }

        let post = posts[postIndex]
        cell.setup(with: post)
        return cell
    }
}

extension LikedPostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bAuth {
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else { return }
            cell.contentView.addGestureRecognizer(doubleTapGesture)
        }
    }
    
    //MARK: Double tap method
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .recognized {
            let touchPoint = recognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                coreDataService.deleteLikedPostIndex(likedPostIndexes[indexPath.row])
                showHeartAnimation(at: indexPath, isLiked: false)
            }
        }
    }
    
    //MARK: Animation
    
    private func showHeartAnimation(at indexPath: IndexPath, isLiked: Bool) {
        let systemNameImage = "heart.fill"

        let heartImageView = UIImageView(image: UIImage(systemName: systemNameImage))
        heartImageView.tintColor = .gray
        heartImageView.frame = CGRect(x: 0, y: 0, width: 65, height: 50)
        heartImageView.center = tableView.cellForRow(at: indexPath)?.center ?? view.center
        heartImageView.alpha = 1

        tableView.addSubview(heartImageView)

        UIView.animate(withDuration: 1.0, animations: {
            heartImageView.center.y += 50
            heartImageView.tintColor = .systemGray
        }) { _ in
            heartImageView.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
}
