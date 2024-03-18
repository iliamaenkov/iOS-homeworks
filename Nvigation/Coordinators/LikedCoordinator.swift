//
//  LikedCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 27.02.2024.
//

import UIKit

final class LikedCoordinator: LikedBaseCoordinator {

    var profileModel: ProfileViewModel
    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()

    init (profileModel: ProfileViewModel){
        self.profileModel = profileModel
    }
    
    func start() -> UIViewController {

        let likedPostViewController = LikedPostsViewController(profileViewModel: profileModel)
        likedPostViewController.view.backgroundColor = .systemBackground
       
        rootViewController = UINavigationController(rootViewController: likedPostViewController)
        return rootViewController
    }
}
