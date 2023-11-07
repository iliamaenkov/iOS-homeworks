//
//  SceneDelegate.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        // MARK: - App Appearance
        
        UIView.appearance().tintColor = UIColor(named: "AppElementsColor")
        
        // MARK: - Window Setup
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)

        // MARK: - View Controllers
        
        let feedViewController: FeedViewController = {
            let viewController = FeedViewController()
            viewController.tabBarItem = UITabBarItem(
                title: "Feed",
                image: UIImage(systemName: "house.fill"),
                tag: 0
            )
            return viewController
        }()
        
        // Creating ProfileViewController
        
        let _: ProfileViewController = {
            let viewController = ProfileViewController()
            return viewController
        }()
        
        // Creating PhotosViewController
        
        let photosViewController: PhotosViewController = {
            let viewController = PhotosViewController()
            return viewController
        }()
        
        let loginViewController: LogInViewController = {
            let viewController = LogInViewController()
            viewController.tabBarItem = UITabBarItem(
                title: "Profile",
                image: UIImage(systemName: "person.fill"),
                tag: 1
            )
            return viewController
        }()
        
        // MARK: - Navigation Controllers
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        let photosNavigationController = UINavigationController(rootViewController: photosViewController)
        // MARK: - Tab Bar Controller
        
        let tabBarController: UITabBarController = {
            let controller = UITabBarController()
            controller.viewControllers = [
                feedNavigationController,
                photosNavigationController,
                loginNavigationController
            ]
            return controller
        }()
        
        // MARK: - Set Root View Controller
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}




