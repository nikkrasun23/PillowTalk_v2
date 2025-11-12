//
//  MainCategoriesSwiftUIViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import SwiftUI
import UIKit

final class MainCategoriesSwiftUIViewController: UIHostingController<MainCategoriesSwiftUIView> {
    private let viewModel = MainCategoriesSwiftUIViewModel()
    private weak var parentTabBarController: TabBarViewController?
    
    init(tabBarController: TabBarViewController?) {
        self.parentTabBarController = tabBarController
        
        let swiftUIView = MainCategoriesSwiftUIView(viewModel: viewModel)
        super.init(rootView: swiftUIView)
        
        setupCallbacks()
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCallbacks() {
        viewModel.onDateJarTap = { [weak self] in
            self?.parentTabBarController?.selectTab(.cup)
        }
        
        viewModel.onInstagramTap = {
            if let url = URL(string: "https://www.instagram.com/pillowtalkapp/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        viewModel.onCategoryTap = { [weak self] categoryId in
            UserDefaultsService.selectedCategoryFromOverlay = categoryId
            
            let categoriesVC = CategoriesAssembler.configure(payload: .init(screenType: .categories))
            
            self?.navigationController?.pushViewController(categoriesVC, animated: true)
        }
        
        viewModel.onSubscribeTap = { [weak self] in
            guard let tabBarController = self?.parentTabBarController else { return }
            IAPManager.shared.presentPaywall(tabBarController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

