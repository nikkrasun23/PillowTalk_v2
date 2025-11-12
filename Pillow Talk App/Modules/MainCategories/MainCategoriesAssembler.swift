//
//  MainCategoriesAssembler.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import UIKit

final class MainCategoriesAssembler {
    static func configure(tabBarController: TabBarViewController?) -> UIViewController {
        return MainCategoriesSwiftUIViewController(tabBarController: tabBarController)
    }
}

