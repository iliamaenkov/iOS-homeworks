//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

protocol ProfileVIewControllerDelegate: AnyObject {
    func scrollOn()
    func scrollOff()
}

extension ProfileViewController: ProfileVIewControllerDelegate {

    func scrollOn() {
        self.tableView.isScrollEnabled = true
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
    }
    
    func scrollOff() {
        self.tableView.isScrollEnabled = false
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
    }
}

final class ProfileViewController: UIViewController {
    
    var user: User?
    var profileHeader: ProfileHeaderView?
    
    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupHeader()
        
#if DEBUG
        tableView.backgroundColor = .systemRed
#else
        tableView.backgroundColor = .systemGray6
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.beginAppearanceTransition(true, animated: true)
          self.endAppearanceTransition()
    
          navigationController?.setNavigationBarHidden(true, animated: true)
      }
    
    
    //MARK: - Private
    
    private func setupHeader() {
        profileHeader = ProfileHeaderView()
        profileHeader?.user = user
        profileHeader?.profileVC = self
    }
    
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

