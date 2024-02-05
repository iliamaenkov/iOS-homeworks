//
//  ProfileCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

class ProfileCoordinator: ProfileBaseCoordinator {
    
    let checkerService = CheckerService()
    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var profileViewModel: ProfileViewModel = ProfileViewModel(service: checkerService)
    
    func start() -> UIViewController {
        profileViewModel.showProfile = { [weak self] in
            self?.showProfile()
        }
        profileViewModel.showPhotoGallery = { [weak self] in
            self?.showPhotoGallery()
        }
        
        let loginViewController = LogInViewController(viewModel: profileViewModel)
        loginViewController.view.backgroundColor = .systemBackground
        
        let loginInspector = MyLoginFactory(checkerService: checkerService).makeLoginInspector()
        loginViewController.loginDelegate = loginInspector
        rootViewController = UINavigationController(
            rootViewController: loginViewController
        )
        
        return rootViewController
    }
    
    func showProfile() {
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
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
