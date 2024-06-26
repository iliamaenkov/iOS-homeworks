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
    case map
}

final class MainCoordinator: MainBaseCoordinator {

    var profileModel: ProfileViewModel
    var feedModel: FeedViewModel
    var parentCoordinator: MainBaseCoordinator?
    
    var feedCoordinator: FeedBaseCoordinator
    var profileCoordinator: ProfileBaseCoordinator
    var likedCoordinator: LikedBaseCoordinator
    var mapCoordinator: MapBaseCoordinator
    
    lazy var rootViewController: UIViewController = UITabBarController()
    
    init (profileModel: ProfileViewModel, feedModel: FeedViewModel) {
        self.profileModel = profileModel
        self.feedModel = feedModel
        self.feedCoordinator = FeedCoordinator(feedViewModel: feedModel)
        self.profileCoordinator = ProfileCoordinator(profileModel: profileModel)
        self.likedCoordinator = LikedCoordinator(profileModel: profileModel)
        self.mapCoordinator = MapCoordinator()
    }
    
    func start() -> UIViewController {
        let feedViewController = feedCoordinator.start()
        feedCoordinator.parentCoordinator = self
        feedViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Feed", comment: "Лента"),
            image: UIImage(
                systemName: "house.fill"),
            tag: 0
        )
        
        let profileViewController = profileCoordinator.start()
        profileCoordinator.parentCoordinator = self
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: "Профиль"),
            image: UIImage(
                systemName: "person.fill"),
            tag: 1
        )
        
        let likedViewController = likedCoordinator.start()
        likedCoordinator.parentCoordinator = self
        likedViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Liked", comment: "Понравилось"),
            image: UIImage(
                systemName: "heart.circle.fill"),
            tag: 2
        )
        
        let mapViewController = mapCoordinator.start()
        mapCoordinator.parentCoordinator = self
        mapViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Map", comment: "Карта"),
            image: UIImage(
                systemName: "map.fill"),
            tag: 3
        )
        UITabBar.appearance().tintColor = lightDark
        (rootViewController as? UITabBarController)?.viewControllers = [feedViewController, profileViewController, likedViewController, mapViewController]
        
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
        case .map:
            (rootViewController as? UITabBarController)?.selectedIndex = 3
        }
    }
    
    func resetToRoot() -> Self {
        feedCoordinator.resetToRoot()
        moveTo(flow: .feed)
        return self
    }
}
