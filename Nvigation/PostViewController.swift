//
//  PostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post?
    
    private static let defaultTitle = "Post"
    private static let infoButtonImage = UIImage(systemName: "arrowshape.turn.up.forward.circle")
    
    // Создаем кнопку в навигационной панели с иконкой
    
    private lazy var infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: PostViewController.infoButtonImage,
            style: .plain,
            target: self,
            action: #selector(showInfoViewController(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = post?.title ?? PostViewController.defaultTitle
        self.view.backgroundColor = .systemGray6
        
        // Устанавливаем созданную кнопку как правую кнопку в навигационной панели
        
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func showInfoViewController(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        
        // Отображаем infoViewController модально
        
        present(infoViewController, animated: true)
    }
}
