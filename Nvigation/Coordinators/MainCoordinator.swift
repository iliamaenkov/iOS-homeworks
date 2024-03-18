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
    case liked
}

final class MainCoordinator: MainBaseCoordinator {
    
    var profileModel: ProfileViewModel
    var feedModel: FeedViewModel
    var parentCoordinator: MainBaseCoordinator?
    
    var feedCoordinator: FeedBaseCoordinator
    var profileCoordinator: ProfileBaseCoordinator
    var likedCoordinator: LikedBaseCoordinator
    
    lazy var rootViewController: UIViewController = UITabBarController()
    
    init (profileModel: ProfileViewModel, feedModel: FeedViewModel) {
        self.profileModel = profileModel
        self.feedModel = feedModel
        self.feedCoordinator = FeedCoordinator(feedViewModel: feedModel)
        self.profileCoordinator = ProfileCoordinator(profileModel: profileModel)
        self.likedCoordinator = LikedCoordinator(profileModel: profileModel)
    }
    
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
        
        let likedViewController = likedCoordinator.start()
        likedCoordinator.parentCoordinator = self
        likedViewController.tabBarItem = UITabBarItem(
            title: "Liked",
            image: UIImage(
                systemName: "heart.circle.fill"),
            tag: 2
        )
        UITabBar.appearance().tintColor = .black
        (rootViewController as? UITabBarController)?.viewControllers = [feedViewController, profileViewController, likedViewController]
        
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 1
        case .liked:
            (rootViewController as? UITabBarController)?.selectedIndex = 2
        }
    }
    
    func resetToRoot() -> Self {
        feedCoordinator.resetToRoot()
        moveTo(flow: .feed)
        return self
    }
}
