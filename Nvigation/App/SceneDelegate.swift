//
//  SceneDelegate.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let profileModel = ProfileViewModel.shared
        let feedModel = FeedViewModel.shared
        
        let mainCoordinator = MainCoordinator(profileModel: profileModel, feedModel: feedModel)
        let rootViewController = mainCoordinator.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController

        self.window = window
        window.makeKeyAndVisible()
        
        if let url = AppConfiguration.people.url {
            NetworkManager.request(url: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("Data: \n\(response.dataString)")
                        print("\nHeaders: \n\(response.headers)")
                        print("\nStatus Code: \(response.statusCode)")
                        
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        if let nsError = error as NSError? {
                            print("Error Code: \(nsError.code)")
                        }
                    }
                }
            }
        }
    }
}
