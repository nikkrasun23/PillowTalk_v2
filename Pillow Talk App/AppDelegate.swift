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
        let country = Locale.current.regionCode ?? "Unknown"
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
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
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
