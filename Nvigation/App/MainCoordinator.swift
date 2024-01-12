//
//  MainCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

enum AppFlow {
    case feed
    case profile
}

class MainCoordinator: MainBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    
    lazy var feedCoordinator: FeedBaseCoordinator = FeedCoordinator()
    lazy var profileCoordinator: ProfileBaseCoordinator = ProfileCoordinator()
    
    lazy var rootViewController: UIViewController = UITabBarController()
    
    func start() -> UIViewController {
        let feedViewController = feedCoordinator.start()
        feedCoordinator.parentCoordinator = self
        feedViewController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(
                systemName: "house.fill"),
            tag: 0
        )
        
        let profileViewController = profileCoordinator.start()
        profileCoordinator.parentCoordinator = self
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(
                systemName: "person.fill"),
            tag: 1
        )
        UITabBar.appearance().tintColor = .black
        (rootViewController as? UITabBarController)?.viewControllers = [feedViewController, profileViewController]
        
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 1
        }
    }
    
    func resetToRoot() -> Self {
        feedCoordinator.resetToRoot()
        moveTo(flow: .feed)
        return self
    }
}
