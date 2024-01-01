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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainCoordinator = MainCoordinator()
        let rootViewController = mainCoordinator.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController

        self.window = window
        window.makeKeyAndVisible()
//        let window = UIWindow(windowScene: windowScene)
//        
//        window.rootViewController = createTabBarController(with: MyLoginFactory())
//        window.makeKeyAndVisible()
//        self.window = window
//        self.window?.overrideUserInterfaceStyle = .light
    }
}

//    //MARK: - Private
//
//    private func createTabBarController(with factory: LoginFactory) -> UITabBarController {
//        
//        let tabBarController = UITabBarController()
//        
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .white
//        
//        setTabBarItemColors(appearance.stackedLayoutAppearance)
//        setTabBarItemColors(appearance.inlineLayoutAppearance)
//        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
//        
//        setTabBarBadgeAppearance(appearance.stackedLayoutAppearance)
//        setTabBarBadgeAppearance(appearance.inlineLayoutAppearance)
//        setTabBarBadgeAppearance(appearance.compactInlineLayoutAppearance)
//        
//        tabBarController.tabBar.standardAppearance = appearance
//        if #available(iOS 15.0, *) {
//            tabBarController.tabBar.scrollEdgeAppearance = appearance
//        }
//        tabBarController.tabBar.isTranslucent = false
//        
//        let feedViewController = FeedViewController()
//        feedViewController.tabBarItem.image = UIImage(systemName: "house.fill")
//        feedViewController.title = "Feed"
//
//        let profileViewController = LogInViewController()
//        profileViewController.tabBarItem.image = UIImage(systemName: "person.fill")
//        profileViewController.title = "Profile"
//        
//        profileViewController.loginDelegate = factory.makeLoginInspector()
//
//        tabBarController.viewControllers = [
//            UINavigationController(rootViewController: feedViewController),
//            UINavigationController(rootViewController: profileViewController)
//        ]
//
//        return tabBarController
//    }
//
//
//    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
//        itemAppearance.normal.iconColor = .systemGray
//        itemAppearance.normal.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
//            NSAttributedString.Key.paragraphStyle: NSParagraphStyle.default
//        ]
//        
//        itemAppearance.selected.iconColor = .black
//        itemAppearance.selected.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.black,
//            NSAttributedString.Key.paragraphStyle: NSParagraphStyle.default
//        ]
//        
//    }
//
//    private func setTabBarBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
//        itemAppearance.normal.badgeBackgroundColor = .systemRed
//        itemAppearance.normal.badgeTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.systemRed
//        ]
//    }
//




