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
    
    public static func debugClear() {
    #if DEBUG
        $isSubscribed.clear()
        $isRated.clear()
        $selectedCategoryFromOverlay.clear()
        $viewedCardsCount.clear()
        $isOnboardingShown.clear()
    #endif
    }
}
