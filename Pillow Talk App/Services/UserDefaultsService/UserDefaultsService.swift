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
    }

    @UserDefaultValue(key: Keys.isSubscribed, defaultValue: false)
    public static var isSubscribed: Bool
    
    @UserDefaultValue(key: Keys.isRated, defaultValue: false)
    public static var isRated: Bool
    
    public static func debugClear() {
    #if DEBUG
        $isSubscribed.clear()
        $isRated.clear()
    #endif
    }
}
