//
//  ProfileCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

final class ProfileCoordinator: ProfileBaseCoordinator {
    
    var profileModel: ProfileViewModel
    let checkerService = CheckerService()
    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    
    init (profileModel: ProfileViewModel){
        self.profileModel = profileModel
    }
    
    func start() -> UIViewController {
        profileModel.showProfile = { [weak self] in
            self?.showProfile()
        }
        profileModel.showPhotoGallery = { [weak self] in
            self?.showPhotoGallery()
        }
        
        let loginViewController = LogInViewController(viewModel: profileModel)
        loginViewController.view.backgroundColor = .systemBackground
        
        let loginInspector = MyLoginFactory(checkerService: checkerService).makeLoginInspector()
        loginViewController.loginDelegate = loginInspector
        rootViewController = UINavigationController(
            rootViewController: loginViewController
        )
        
        return rootViewController
    }
    
    func showProfile() {
        let profileViewController = ProfileViewController(viewModel: profileModel)
        navigationRootViewController?.pushViewController(profileViewController, animated: true)
    }
    
    func showPhotoGallery() {
        let photosViewController = PhotosViewController()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationRootViewController?.navigationItem.backBarButtonItem = backButton
        navigationRootViewController?.pushViewController(photosViewController, animated: true)
    }
}
