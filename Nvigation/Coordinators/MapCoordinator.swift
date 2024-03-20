//
//  MapCoordinator.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.03.2024.
//

import UIKit

final class MapCoordinator: MapBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {

        let mapViewController = MapViewController()
        mapViewController.view.backgroundColor = .systemBackground
       
        rootViewController = UINavigationController(rootViewController: mapViewController)
        return rootViewController
    }
}
