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
    /// 1. Если есть кеш - планирует из кеша
    /// 2. Если нет кеша - грузит с Firebase, кеширует и планирует
    func setupNotificationsOnFirstLaunch(with language: DataLanguage, completion: @escaping (Bool) -> Void) {
        // 1. Проверяем есть ли кеш
        if UserDefaultsService.hasNotificationMessages {
            scheduleNotificationsFromCache(language: language)
            completion(true)
            return
        }
        
        // 2. Грузим с Firebase при первом запуске
        FirebaseService().getLocalNotifications(with: language) { result in
            switch result {
            case .success(let messages):
                UserDefaultsService.saveNotificationMessages(messages)
                self.scheduleNotifications(with: messages, language: language)
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
        let messages = UserDefaultsService.notificationMessages
        guard !messages.isEmpty else { return }
        scheduleNotifications(with: messages, language: language)
    }
    
    /// Обновляет сообщения если нужно (вызывать при открытии апки или по тапу на пуш)
    func refreshMessagesIfNeeded(with language: DataLanguage) {
        guard UserDefaultsService.shouldRefreshNotificationMessages() else {
            return
        }
        
        FirebaseService().getLocalNotifications(with: language) { result in
            if case .success(let messages) = result {
                UserDefaultsService.saveNotificationMessages(messages)
                self.rescheduleNotifications(with: messages, language: language)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func scheduleNotifications(with messages: [String], language: DataLanguage) {
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
                title: language.notificationTitle,
                atHour: 20,
                minute: 0,
                daysAhead: 14
            )
            
            #if DEBUG
            NotificationScheduler.shared.scheduleIn(
                seconds: 5,
                message: messages.first ?? "Test",
                title: language.notificationTitle
            )
            #endif
        }
    }
    
    private func rescheduleNotifications(with messages: [String], language: DataLanguage) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleNotifications(with: messages, language: language)
    }
}

