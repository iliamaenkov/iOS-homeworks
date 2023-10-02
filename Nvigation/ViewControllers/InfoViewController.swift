//
//  InfoViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Создаем кнопку "Show Alert"
        
        let showAlertButton = UIButton(type: .system)
        showAlertButton.setTitle("Show Alert", for: .normal)
        showAlertButton.addTarget(self, action: #selector(showAlertTapped(_:)), for: .touchUpInside)
        
        showAlertButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showAlertButton)
        
        NSLayoutConstraint.activate([
            showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showAlertTapped(_ sender: UIButton) {
        
        // Создаем экземпляр UIAlertController для отображения всплывающего сообщения
        
        let alertController = UIAlertController(
            title: "Alert Window",
            message: "Alert Message",
            preferredStyle: .alert
        )
        
        // Создаем кнопки "OK" и "Cancel" для UIAlertController, а также два безымянных замыкания для вывода сообщений в консоль при нажатии на соответствующие кнопки
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }

        // Добавляем созданные кнопки к UIAlertController
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
