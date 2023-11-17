//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - UI Elements
    
    lazy var tableView: UITableView = {
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
        
        #if DEBUG
        tableView.backgroundColor = .systemGray
        #else
        tableView.backgroundColor = .white
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: - Private
    
    private func tuneTableView() {
        
        view.addSubview( tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

