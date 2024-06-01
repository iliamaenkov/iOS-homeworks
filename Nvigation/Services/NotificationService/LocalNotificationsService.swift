//
//  LocalNotificationsService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 25.04.2024.
//

import UserNotifications

final class LocalNotificationsService {
    
    private let notificationIdentifier = "DailyUpdateNotification"
    
    func requestAuthorization() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print("Ошибка при запросе разрешения на уведомления.")
            }
        }
    }
    
    func getStatusAuthorization() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized
    }
    
    func registeForLatestUpdatesIfPossible() async {
        let isAuthorized = await getStatusAuthorization()
        
        if isAuthorized {
            let content = UNMutableNotificationContent()
            content.title = "Новое уведомление"
            content.body = "Посмотрите последние обновления"
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 19
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            
            try? await UNUserNotificationCenter.current().add(request)
        } else {
            print("Разрешение на уведомления не получено.")
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}


