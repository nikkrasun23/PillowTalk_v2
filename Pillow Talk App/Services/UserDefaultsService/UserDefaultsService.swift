//
//  UserDefaultsService.swift
//  PromCoreKit
//
//  Created by v.vasylyda on 23.12.2020.
//

import Foundation

final class UserDefaultsService: NSObject {
    public enum Keys: String {
        case isSubscribed
        case isRated
        case viewedCardsCount
        case viewedCardsDate
        case isOnboardingShown
        case isOnboardingCompleted
        case selectedCategoryFromOverlay
        case notificationMessages
        case notificationTitle
        case notificationMessagesLastUpdate
        case notificationMessagesLanguage
        case localNotificationsEnabled
        case shownCardsCount
    }

    @UserDefaultValue(key: Keys.isSubscribed, defaultValue: false)
    public static var isSubscribed: Bool
    
    @UserDefaultValue(key: Keys.isRated, defaultValue: false)
    public static var isRated: Bool
    
    @UserDefaultValue(key: Keys.viewedCardsCount, defaultValue: 0)
    public static var viewedCardsCount: Int
    
    @UserDefaultValue(key: Keys.viewedCardsDate, defaultValue: nil)
    public static var viewedCardsDate: Date?
    
    @UserDefaultValue(key: Keys.isOnboardingShown, defaultValue: false)
    public static var isOnboardingShown: Bool
    
    @UserDefaultValue(key: Keys.isOnboardingCompleted, defaultValue: false)
    public static var isOnboardingCompleted: Bool
    
    @UserDefaultValue(key: Keys.selectedCategoryFromOverlay, defaultValue: nil)
    public static var selectedCategoryFromOverlay: Int?
    
    @UserDefaultValue(key: Keys.notificationMessages, defaultValue: [])
    public static var notificationMessages: [String]
    
    @UserDefaultValue(key: Keys.notificationTitle, defaultValue: nil)
    public static var notificationTitle: String?
    
    @UserDefaultValue(key: Keys.notificationMessagesLastUpdate, defaultValue: nil)
    public static var notificationMessagesLastUpdate: Date?
    
    @UserDefaultValue(key: Keys.notificationMessagesLanguage, defaultValue: nil)
    public static var notificationMessagesLanguage: String?
    
    @UserDefaultValue(key: Keys.localNotificationsEnabled, defaultValue: true)
    public static var localNotificationsEnabled: Bool
    
    @UserDefaultValue(key: Keys.shownCardsCount, defaultValue: 0)
    public static var shownCardsCount: Int
    
    public static func resetViewedCardsIfNeeded() {
        guard let savedDate = viewedCardsDate else { return }
        
        let now = Date()
        if !Calendar.current.isDate(now, inSameDayAs: savedDate) {
            viewedCardsCount = 0
            viewedCardsDate = now
        }
    }

    public static func incrementViewedCards() {
        resetViewedCardsIfNeeded()
        viewedCardsCount += 1

        if viewedCardsDate == nil {
            viewedCardsDate = Date()
        }
    }

    static var hasReachedDailyLimit: Bool {
        resetViewedCardsIfNeeded()
        return viewedCardsCount >= 5
    }
    
    // MARK: - Notification Messages Cache
    
    public static var hasNotificationMessages: Bool {
        return !notificationMessages.isEmpty
    }
    
    public static func shouldRefreshNotificationMessages(for language: DataLanguage) -> Bool {
        // Проверяем, совпадает ли язык кеша с текущим языком
        if notificationMessagesLanguage != language.rawValue {
            return true
        }
        
        guard let lastUpdate = notificationMessagesLastUpdate else {
            return true
        }
        return Date().timeIntervalSince(lastUpdate) >= 24 * 3600
    }
    
    public static func saveNotificationData(_ notificationData: NotificationDataModel, for language: DataLanguage) {
        notificationMessages = notificationData.messages
        // Сохраняем title из Firebase, если он есть, иначе используем fallback
        notificationTitle = notificationData.title ?? language.notificationTitle
        notificationMessagesLanguage = language.rawValue
        notificationMessagesLastUpdate = Date()
    }
    
    public static func isNotificationMessagesLanguageMatching(_ language: DataLanguage) -> Bool {
        return notificationMessagesLanguage == language.rawValue
    }
    
    public static func debugClear() {
    #if DEBUG
        $isSubscribed.clear()
        $isRated.clear()
        $selectedCategoryFromOverlay.clear()
        $viewedCardsCount.clear()
        $isOnboardingShown.clear()
        $isOnboardingCompleted.clear()
        $notificationMessages.clear()
        $notificationTitle.clear()
        $notificationMessagesLastUpdate.clear()
        $notificationMessagesLanguage.clear()
    #endif
    }
}
