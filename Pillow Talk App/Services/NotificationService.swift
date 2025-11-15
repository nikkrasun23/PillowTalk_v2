//
//  NotificationService.swift
//  Pillow Talk App
//
//  Created by Assistant on 13/10/2025.
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Настраивает нотификации при первом запуске:
    /// 1. Если есть кеш и язык совпадает - планирует из кеша
    /// 2. Если нет кеша или язык не совпадает - грузит с Firebase, кеширует и планирует
    func setupNotificationsOnFirstLaunch(with language: DataLanguage, completion: @escaping (Bool) -> Void) {
        // 1. Проверяем есть ли кеш и совпадает ли язык
        if UserDefaultsService.hasNotificationMessages && UserDefaultsService.isNotificationMessagesLanguageMatching(language) {
            scheduleNotificationsFromCache(language: language)
            completion(true)
            return
        }
        
        // 2. Грузим с Firebase при первом запуске или если язык не совпадает
        FirebaseService().getLocalNotifications(with: language) { result in
            switch result {
            case .success(let notificationData):
                UserDefaultsService.saveNotificationData(notificationData, for: language)
                let title = notificationData.title(with: language.notificationTitle)
                self.scheduleNotifications(with: notificationData.messages, title: title)
                completion(true)
            case .failure(let error):
                print("Failed to fetch notification messages: \(error)")
                completion(false)
            }
        }
    }
    
    /// Запрашивает разрешения и запускает планирование
    func requestPermissionsAndSchedule(with language: DataLanguage) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
            
            if granted {
                self.setupNotificationsOnFirstLaunch(with: language) { _ in }
            }
        }
    }
    
    /// Планирует нотификации из кеша
    func scheduleNotificationsFromCache(language: DataLanguage) {
        // Проверяем, что язык кеша совпадает с текущим языком
        guard UserDefaultsService.isNotificationMessagesLanguageMatching(language) else {
            // Если язык не совпадает, загружаем новые сообщения
            FirebaseService().getLocalNotifications(with: language) { result in
                if case .success(let notificationData) = result {
                    UserDefaultsService.saveNotificationData(notificationData, for: language)
                    let title = notificationData.title(with: language.notificationTitle)
                    self.scheduleNotifications(with: notificationData.messages, title: title)
                }
            }
            return
        }
        
        let messages = UserDefaultsService.notificationMessages
        let title = UserDefaultsService.notificationTitle ?? language.notificationTitle
        guard !messages.isEmpty else { return }
        scheduleNotifications(with: messages, title: title)
    }
    
    /// Обновляет сообщения если нужно (вызывать при открытии апки или по тапу на пуш)
    func refreshMessagesIfNeeded(with language: DataLanguage) {
        guard UserDefaultsService.shouldRefreshNotificationMessages(for: language) else {
            return
        }
        
        FirebaseService().getLocalNotifications(with: language) { result in
            if case .success(let notificationData) = result {
                UserDefaultsService.saveNotificationData(notificationData, for: language)
                let title = notificationData.title(with: language.notificationTitle)
                self.rescheduleNotifications(with: notificationData.messages, title: title)
            }
        }
    }
    
    // MARK: - Test Methods (DEBUG only)
    
    #if DEBUG
    /// Отправляет тестовое уведомление через указанное количество секунд
    /// Использовать для тестирования на эмуляторе
    func sendTestNotification(after seconds: TimeInterval = 3, with language: DataLanguage? = nil) {
        let currentLanguage: DataLanguage
        
        if let lang = language {
            currentLanguage = lang
        } else {
            guard let langCode = Locale.current.language.languageCode?.identifier,
                  let lang = DataLanguage(rawValue: langCode) else {
                print("⚠️ Cannot determine language for test notification")
                return
            }
            currentLanguage = lang
        }
        
        // Получаем сообщения из кеша или Firebase
        let messages = UserDefaultsService.notificationMessages
        let title = UserDefaultsService.notificationTitle ?? currentLanguage.notificationTitle
        
        if messages.isEmpty {
            // Если кеш пустой, загружаем из Firebase
            FirebaseService().getLocalNotifications(with: currentLanguage) { result in
                switch result {
                case .success(let notificationData):
                    let testTitle = notificationData.title(with: currentLanguage.notificationTitle)
                    let testMessage = notificationData.messages.first ?? "Test notification"
                    NotificationScheduler.shared.scheduleIn(
                        seconds: seconds,
                        message: testMessage,
                        title: testTitle
                    )
                    print("✅ Test notification scheduled for \(seconds) seconds")
                    print("   Title: \(testTitle)")
                    print("   Message: \(testMessage)")
                case .failure(let error):
                    print("❌ Failed to load test notification: \(error)")
                }
            }
        } else {
            let testMessage = messages.first ?? "Test notification"
            NotificationScheduler.shared.scheduleIn(
                seconds: seconds,
                message: testMessage,
                title: title
            )
            print("✅ Test notification scheduled for \(seconds) seconds")
            print("   Title: \(title)")
            print("   Message: \(testMessage)")
        }
    }
    
    /// Отправляет тестовое уведомление немедленно (через 1 секунду)
    func sendTestNotificationNow(with language: DataLanguage? = nil) {
        sendTestNotification(after: 1, with: language)
    }
    #endif
    
    // MARK: - Private Methods
    
    private func scheduleNotifications(with messages: [String], title: String) {
        // Проверяем включены ли локальные уведомления
        guard UserDefaultsService.localNotificationsEnabled else {
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
                return
            }
            
            NotificationScheduler.shared.scheduleDailyNotifications(
                using: messages,
                title: title,
                atHour: 20,
                minute: 0,
                daysAhead: 14
            )
            
            #if DEBUG
            NotificationScheduler.shared.scheduleIn(
                seconds: 5,
                message: messages.first ?? "Test",
                title: title
            )
            #endif
        }
    }
    
    private func rescheduleNotifications(with messages: [String], title: String) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleNotifications(with: messages, title: title)
    }
}


