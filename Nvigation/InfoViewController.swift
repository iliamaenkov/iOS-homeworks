//
//  InfoViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    var postTitle: PostTitle?
    
    //MARK: - UI Elements
    
    private lazy var showAlert: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View Controller Lifecycle
    
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
    
    //MARK: - Actions
    
    @objc func showAlert(_ sender: UIButton) {
        
        // Create an instance of UIAlertController to display a pop-up message
        
        let alertController = UIAlertController(
            title: "Alert Window",
            message: "Alert Message",
            preferredStyle: .alert
        )
        
        // Create "OK" and "Cancel" buttons for the UIAlertController, which will display corresponding messages in the console
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        
        // Add the created buttons to the UIAlertController
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
