//
//  PostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var postTitle: PostTitle?
    
    private static let defaultTitle = "Post"
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
        
        self.title = postTitle?.title ?? PostViewController.defaultTitle
        self.view.backgroundColor = .systemGray6
        
        // Set the created button as the right button in the navigation bar
        
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - Actions
    
    @objc func showInfoViewController(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        
        // Display infoViewController modally
        
        present(infoViewController, animated: true)
    }
}
