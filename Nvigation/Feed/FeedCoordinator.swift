//
//  FeedCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

class FeedCoordinator: FeedBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var feedViewModel: FeedViewModel = FeedViewModel()

    func start() -> UIViewController {
        feedViewModel.show = { [weak self] in
            self?.showPost()
        }

        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.view.backgroundColor = .systemBackground
       
        rootViewController = UINavigationController(
            rootViewController: feedViewController
        )

        
        return rootViewController
    }
    
    func showPost() {
        let postViewController = PostViewController()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationRootViewController?.navigationItem.backBarButtonItem = backButton
        navigationRootViewController?.pushViewController(postViewController, animated: true)
    }
}
