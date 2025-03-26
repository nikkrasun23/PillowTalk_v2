//
//  IAPManager.swift
//  FakeGame
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation
import RevenueCat
import RevenueCatUI
import UIKit

final class IAPManager: NSObject {
    // MARK: - Properties
    static let shared = IAPManager()
    
    func fetchSubscribtionStatus() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            UserDefaultsService.isSubscribed = customerInfo?.entitlements["Regular SUB"]?.isActive ?? false
        }
    }
    
    func presentPaywall(_ viewController: UIViewController) {
        Purchases.shared.getOfferings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages, !packages.isEmpty {
                let controller = PaywallViewController()
                controller.delegate = self

                viewController.present(controller, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Підписки недоступні",
                                                  message: "Підписки тимчасово недоступні. Ви можете ознайомитися з ними в описі програми.",
                                                  preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.present(alert, animated: true)
            }
        }
    }
}

extension IAPManager: PaywallViewControllerDelegate {
    func paywallViewController(_ controller: PaywallViewController,
                               didFinishPurchasingWith customerInfo: CustomerInfo) {
        UserDefaultsService.isSubscribed = customerInfo.entitlements["Regular SUB"]?.isActive ?? false
    }
}
