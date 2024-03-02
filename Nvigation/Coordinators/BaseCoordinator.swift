//
//  BaseCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.12.2023.
//

import UIKit

typealias Action = (() -> Void)

protocol FlowCoordinator: AnyObject {
    var parentCoordinator: MainBaseCoordinator? { get set }
}

protocol Coordinator: FlowCoordinator {
    var rootViewController: UIViewController { get set }
    func start() -> UIViewController
    @discardableResult func resetToRoot() -> Self
}

extension Coordinator {
    var navigationRootViewController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}

protocol FeedBaseCoordinator: Coordinator {
    func showPost()
}

protocol ProfileBaseCoordinator: Coordinator {
    func showProfile()
    func showPhotoGallery()
}

protocol LikedBaseCoordinator: Coordinator {

}

protocol MainBaseCoordinator: Coordinator {
    var feedCoordinator: FeedBaseCoordinator { get }
    var profileCoordinator: ProfileBaseCoordinator { get }
    var likedCoordinator: LikedBaseCoordinator { get }
    func moveTo(flow: AppFlow)
}
