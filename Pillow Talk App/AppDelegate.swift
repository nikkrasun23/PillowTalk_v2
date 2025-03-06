//
//  AppDelegate.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

//import UIKit
//import FirebaseCore
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//}

import UIKit
import FirebaseCore
import FirebaseAnalytics // Импорт Analytics для кастомных событий

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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
