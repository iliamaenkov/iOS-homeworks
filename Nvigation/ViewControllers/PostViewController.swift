//
//  PostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    var postTitle: PostTitle?
    var post: Post?
    
    private static let defaultTitle = NSLocalizedString("Post", comment: "Пост")
    private static let infoButtonImage = UIImage(systemName: "arrowshape.turn.up.forward.circle")
    
    // MARK: - UI Elements
        
        // Create a button in the navigation bar with an icon
    
    private lazy var infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: PostViewController.infoButtonImage,
            style: .plain,
            target: self,
            action: #selector(showInfoViewController(_:)))
        return button
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = postTitle?.title ?? PostViewController.defaultTitle
        view.backgroundColor = .systemGray6
        tabBarController?.tabBar.barTintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = infoButton
        navigationController?.navigationBar.tintColor = lightDark
        navigationController?.isNavigationBarHidden = false

    }
    
    // MARK: - Actions
    
    @objc func showInfoViewController(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
    
        present(infoViewController, animated: true)
    }
}
