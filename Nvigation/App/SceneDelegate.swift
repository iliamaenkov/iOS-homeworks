//
//  SceneDelegate.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appConfiguration: AppConfiguration?

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

        let urls = [
            URL(string: "https://swapi.dev/api/people/8")!,
            URL(string: "https://swapi.dev/api/starships/3")!,
            URL(string: "https://swapi.dev/api/planets/5")!
        ]
        appConfiguration = [AppConfiguration.people(urls[0]), .starships(urls[1]), .planets(urls[2])].randomElement()!

        if let config = appConfiguration {
            NetworkManager.request(for: config) { result in
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

