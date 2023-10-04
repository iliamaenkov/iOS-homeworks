//
//  FeedViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    let post = Post(title: "New Post")
    
    //Добавляем кнопку для показа деталей поста
    
    lazy var showPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Post", for: .normal)
        button.addTarget(self, action: #selector(showPostTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        self.title = "Feed"

        view.addSubview(showPostButton)
        
        showPostButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showPostTapped() {
        let postViewController = PostViewController()
        postViewController.post = post

        // Помещаем PostViewController в стек навигации для отображения
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}
