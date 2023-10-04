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
        // Устанавливаем общий цвет для всех Buttons и TabBarItems
        
        UIView.appearance().tintColor = UIColor(named: "AppElementsColor")
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        // Создаем контроллер представления для ленты новостей и соответствующий навигационный контроллер
        
        let feedViewController: FeedViewController = {
            let viewController = FeedViewController()
            viewController.tabBarItem = UITabBarItem(
                title: "Feed",
                image: UIImage(systemName: "newspaper"),
                tag: 0
            )
            return viewController
        }()
        
        // Создаем контроллер представления для профиля и соответствующий навигационный контроллер
        
        let profileViewController: ProfileViewController = {
            let viewController = ProfileViewController()
            viewController.tabBarItem = UITabBarItem(
                title: "Profile",
                image: UIImage(systemName: "person.circle"),
                tag: 1
            )
            return viewController
        }()
        
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let tabBarController: UITabBarController = {
            let controller = UITabBarController()
            controller.viewControllers = [feedNavigationController, profileNavigationController]
            return controller
        }()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}




