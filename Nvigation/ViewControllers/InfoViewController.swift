//
//  InfoViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    var post: Post?
    
    // Создаем кнопку "Show Alert"
    
    lazy var showAlert: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Show Alert", for: .normal)
            button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
        view.addSubview(showAlert)
        
        showAlert.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showAlert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlert.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showAlert(_ sender: UIButton) {
        
        // Создаем экземпляр UIAlertController для отображения всплывающего сообщения
        
        let alertController = UIAlertController(
            title: "Alert Window",
            message: "Alert Message",
            preferredStyle: .alert
        )
        
        // Создаем кнопки "OK" и "Cancel" для UIAlertController, которые будут выводить соответствующие сообщения в консоль
        
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
