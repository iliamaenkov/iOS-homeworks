//
//  ProfileCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

class ProfileCoordinator: ProfileBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    func start() -> UIViewController {
        profileViewModel.showProfile = { [weak self] in
            self?.showProfile()
        }
        profileViewModel.showPhotoGallery = { [weak self] in
            self?.showPhotoGallery()
        }
        
        let loginViewController = LogInViewController(viewModel: profileViewModel)
        loginViewController.view.backgroundColor = .systemBackground
        
        let loginInspector = MyLoginFactory().makeLoginInspector()
        loginViewController.loginDelegate = loginInspector
        rootViewController = UINavigationController(
            rootViewController: loginViewController
        )
        
        return rootViewController
    }
    
    func showProfile() {
        
#if DEBUG
        let service = TestUserService()
#else
        let service = CurrentUserService()
#endif
        let profileViewController = ProfileViewController(
            user: service.user, viewModel: profileViewModel
        )
        navigationRootViewController?.pushViewController(profileViewController, animated: true)
        profileViewController.hidesBottomBarWhenPushed = false
    }
    
    func showPhotoGallery() {
        let photosViewController = PhotosViewController()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        navigationRootViewController?.navigationItem.backBarButtonItem = backButton
        navigationRootViewController?.pushViewController(photosViewController, animated: true)
    }
}
