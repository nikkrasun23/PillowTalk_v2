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
        case selectedCategoryFromOverlay
        case notificationMessages
        case notificationMessagesLastUpdate
        case localNotificationsEnabled
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
    
    @UserDefaultValue(key: Keys.selectedCategoryFromOverlay, defaultValue: nil)
    public static var selectedCategoryFromOverlay: Int?
    
    @UserDefaultValue(key: Keys.notificationMessages, defaultValue: [])
    public static var notificationMessages: [String]
    
    @UserDefaultValue(key: Keys.notificationMessagesLastUpdate, defaultValue: nil)
    public static var notificationMessagesLastUpdate: Date?
    
    @UserDefaultValue(key: Keys.localNotificationsEnabled, defaultValue: true)
    public static var localNotificationsEnabled: Bool
    
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
    
    public static func shouldRefreshNotificationMessages() -> Bool {
        guard let lastUpdate = notificationMessagesLastUpdate else {
            return true
        }
        return Date().timeIntervalSince(lastUpdate) >= 24 * 3600
    }
    
    public static func saveNotificationMessages(_ messages: [String]) {
        notificationMessages = messages
        notificationMessagesLastUpdate = Date()
    }
    
    public static func debugClear() {
    #if DEBUG
        $isSubscribed.clear()
        $isRated.clear()
        $selectedCategoryFromOverlay.clear()
        $viewedCardsCount.clear()
        $isOnboardingShown.clear()
        $notificationMessages.clear()
        $notificationMessagesLastUpdate.clear()
    #endif
    }
}
