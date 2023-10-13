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
        
        UIView.appearance().tintColor = UIColor(named: "AppElementsColor")
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)

        
        let feedViewController: FeedViewController = {
            let viewController = FeedViewController()
            viewController.tabBarItem = UITabBarItem(
                title: "Feed",
                image: UIImage(systemName: "house.fill"),
                tag: 0
            )
            return viewController
        }()
        
        
        let profileViewController: ProfileViewController = {
            let viewController = ProfileViewController()
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
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let tabBarController: UITabBarController = {
            let controller = UITabBarController()
            controller.viewControllers = [
                feedNavigationController,
                profileNavigationController,
                loginNavigationController
            ]
            return controller
        }()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}




