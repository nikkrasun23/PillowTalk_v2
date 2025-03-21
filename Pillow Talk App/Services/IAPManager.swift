//
//  IAPManager.swift
//  FakeGame
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import RevenueCat

final class IAPManager: NSObject {
    // MARK: - Properties
    static let shared = IAPManager()
    
    func fetchSubscribtionStatus() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            UserDefaultsService.isSubscribed = customerInfo?.entitlements["Regular SUB"]?.isActive ?? false
        }
    }
}
