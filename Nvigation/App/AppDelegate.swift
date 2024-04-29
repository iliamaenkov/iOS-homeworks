//
//  AppDelegate.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import Firebase

@main class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let localNotificationsService = LocalNotificationsService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        Task {
            localNotificationsService.requestAuthorization()
            
            let isAuthorized = await localNotificationsService.getStatusAuthorization()
            if isAuthorized {
                await localNotificationsService.registeForLatestUpdatesIfPossible()
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        localNotificationsService.cancelAllNotifications()
        try? Auth.auth().signOut()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

