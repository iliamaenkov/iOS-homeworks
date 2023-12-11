//
//  PostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    weak var feedViewController: FeedViewController?

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
        title = postTitle?.title ?? PostViewController.defaultTitle
        view.backgroundColor = .systemGray6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = infoButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Возвращаем состояние лэйбла проверки в исходное состояние, очищаем поле для секретного слова
        feedViewController?.feedView.resultLabel.backgroundColor = .black
        feedViewController?.feedView.guessTextField.text = ""
        feedViewController?.feedView.setButtonInteractionEnabled(false)
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
