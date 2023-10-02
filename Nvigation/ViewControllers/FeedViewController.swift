//
//  FeedViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    let post = Post(title: "New Post")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        self.title = "Feed"
        
        //Добавляем кнопку для показа деталей поста
        
        let showPostButton = UIButton(type: .system)
        showPostButton.setTitle("Show Post", for: .normal)
        showPostButton.addTarget(self, action: #selector(showPostTapped), for: .touchUpInside)
        
        showPostButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPostButton)
        
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
