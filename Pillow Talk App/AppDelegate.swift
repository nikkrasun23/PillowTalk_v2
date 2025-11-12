//
//  AppDelegate.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import UIKit
import FirebaseAnalytics
import FirebaseCore
import RevenueCat
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Переменная для отслеживания времени сессии
    var sessionStartTime: TimeInterval?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Инициализация Firebase
        FirebaseApp.configure()
        
        // Логирование модели устройства
        logDeviceModel()
        
        // Логирование страны пользователя
        logUserCountry()
        
        // revenue cat
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_czbNyLwVCHFvXDwaoXvjCiKgQBQ")
        
        UserDefaultsService.isRated = false
        UserDefaultsService.selectedCategoryFromOverlay = 0
        
        UserDefaultsService.debugClear()
        
        UNUserNotificationCenter.current().setBadgeCount(.zero)
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        requestNotificationPermissions(application)
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Фиксация начала сессии
        sessionStartTime = Date().timeIntervalSince1970
        
        // Обновляем сообщения нотификаций если нужно
        if let currentLanguage = Locale.current.language.languageCode?.identifier,
           let dataLanguage = DataLanguage(rawValue: currentLanguage) {
            NotificationService.shared.refreshMessagesIfNeeded(with: dataLanguage)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Фиксация конца сессии и логирование времени в приложении
        guard let startTime = sessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince1970 - startTime

        Analytics.logEvent("time_spent_in_app", parameters: [
            "duration": sessionDuration // Логируем время в секундах
        ])
    }

    // Логирование модели устройства
    func logDeviceModel() {
        let deviceModel = UIDevice.current.model
        Analytics.logEvent("device_model_logged", parameters: [
            "device_model": deviceModel
        ])
    }

    // Логирование страны пользователя
    func logUserCountry() {
        let country = Locale.current.region?.identifier ?? "Unknown"
        Analytics.logEvent("country_logged", parameters: [
            "country": country
        ])
    }
    
    private func requestNotificationPermissions(_ application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Логируем событие показываемого уведомления
        logNotificationShown(notification: notification)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Юзер открыл апку по пушу - обновляем кеш сообщений
        if let currentLanguage = Locale.current.language.languageCode?.identifier,
           let dataLanguage = DataLanguage(rawValue: currentLanguage) {
            NotificationService.shared.refreshMessagesIfNeeded(with: dataLanguage)
        }
        
        // Логируем событие открытия уведомления
        logNotificationOpened(notification: response.notification)
        
        completionHandler()
    }
    
    // MARK: - Analytics Helpers
    
    /// Логирует событие показа уведомления
    private func logNotificationShown(notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let notificationType = userInfo["notification_type"] as? String ?? "remote"
        
        var parameters: [String: Any] = [
            "notification_type": notificationType,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        if notificationType == "local" {
            // Для локальных уведомлений добавляем дополнительную информацию
            if let language = userInfo["language"] as? String {
                parameters["language"] = language
            }
            if let source = userInfo["notification_source"] as? String {
                parameters["source"] = source
            }
            if let title = userInfo["title"] as? String {
                parameters["title"] = title
            }
            
            Analytics.logEvent("notification_shown", parameters: parameters)
        } else {
            // Для удаленных уведомлений логируем стандартные параметры
            let reminderType = userInfo["reminder_type"] as? String ?? "unspecified"
            let appName = userInfo["app_name"] as? String ?? "unknown"
            parameters["reminder_type"] = reminderType
            parameters["app_name"] = appName
            
            Analytics.logEvent("notification_shown", parameters: parameters)
        }
    }
    
    /// Логирует событие открытия уведомления
    private func logNotificationOpened(notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let notificationType = userInfo["notification_type"] as? String ?? "remote"
        
        var parameters: [String: Any] = [
            "notification_type": notificationType,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        if notificationType == "local" {
            // Для локальных уведомлений
            if let language = userInfo["language"] as? String {
                parameters["language"] = language
            }
            if let source = userInfo["notification_source"] as? String {
                parameters["source"] = source
            }
            if let title = userInfo["title"] as? String {
                parameters["title"] = title
            }
            if let message = userInfo["message"] as? String {
                // Ограничиваем длину сообщения для аналитики
                let truncatedMessage = String(message.prefix(100))
                parameters["message_preview"] = truncatedMessage
            }
            
            // Основное событие для локальных уведомлений
            Analytics.logEvent("notification_opened", parameters: parameters)
            
            // Дополнительное событие для совместимости со старым кодом
            Analytics.logEvent("open_app_from_local_notification", parameters: parameters)
        } else {
            // Для удаленных уведомлений (remote push)
            let reminderType = userInfo["reminder_type"] as? String ?? "unspecified"
            let appName = userInfo["app_name"] as? String ?? "unknown"
            parameters["reminder_type"] = reminderType
            parameters["app_name"] = appName
            
            // Основное событие
            Analytics.logEvent("notification_opened", parameters: parameters)
            
            // Старое событие для обратной совместимости
            Analytics.logEvent("open_app_from_reminder", parameters: [
                "app_name": appName,
                "reminder_type": reminderType,
                "timestamp": Date().timeIntervalSince1970
            ])
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase FCM Token: \(fcmToken ?? "")")
        guard let fcmToken = fcmToken else { return }
        
        FirebaseService().saveFCMTokenToFirestore(fcmToken)
    }
}
