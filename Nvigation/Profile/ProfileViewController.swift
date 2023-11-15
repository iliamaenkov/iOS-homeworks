//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - UI Elements
    
    static var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        
        return tableView
    }()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuneTableView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: - Private
    
    private func tuneTableView() {
        
        view.addSubview( ProfileViewController.tableView)
        
        ProfileViewController.tableView.delegate = self
        ProfileViewController.tableView.dataSource = self

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ProfileViewController.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            ProfileViewController.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ProfileViewController.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ProfileViewController.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

