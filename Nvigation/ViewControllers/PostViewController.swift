//
//  PostViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Устанавливаем заголовок контроллера, используя заголовок поста (если он есть)
        
        self.title = post?.title ?? "Post"
        //Меняем цвет view
        self.view.backgroundColor = .systemGray6
        
        // Создаем кнопку в навигационной панели с иконкой
        
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.forward.circle"),
            style: .plain,
            target: self,
            action: #selector(buttonTapped(_:)))
        
        // Устанавливаем созданную кнопку как правую кнопку в навигационной панели
        
        self.navigationItem.rightBarButtonItem = button
    }

    @objc func buttonTapped(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        
        // Отображаем infoViewController модально
        
        present(infoViewController, animated: true)
    }
}
