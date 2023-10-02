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
        
        let feedViewController = FeedViewController()
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        feedViewController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "newspaper"),
            tag: 0
        )
        
        // Создаем контроллер представления для профиля и соответствующий навигационный контроллер
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 1
        )
        
        let tabBarController = UITabBarController()
        
        let controllers = [feedNavigationController, profileNavigationController]
        tabBarController.viewControllers = controllers
        
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}




