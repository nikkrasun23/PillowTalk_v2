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
    }

    @UserDefaultValue(key: Keys.isSubscribed, defaultValue: false)
    public static var isSubscribed: Bool
    
    public static func debugClear() {
    #if DEBUG
        $isSubscribed.clear()
    #endif
    }
}
