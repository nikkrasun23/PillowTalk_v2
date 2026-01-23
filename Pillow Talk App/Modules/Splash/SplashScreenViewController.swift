//
//  SplashScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 25.12.2024.
//

import UIKit

class SplashScreenViewController: UIViewController {
    var splashScreenView: SplashScreenView!
    
    private let firebaseService: FirebaseService = FirebaseService()

    override func loadView() {
        // Инициализируем кастомный SplashScreenView
        splashScreenView = SplashScreenView(frame: UIScreen.main.bounds)
        self.view = splashScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        // Добавляем задержку и переход на следующий экран
        
        fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToFirstScreen()
        }
    }

    private func navigateToFirstScreen() {
        IAPManager.shared.fetchSubscribtionStatus()
        
        if UserDefaultsService.isOnboardingCompleted {
            presentTabBar()
        } else {
            let onboardingVC = OnboardingAssembler.configure { [weak self] in
                guard let self else { return }
                self.presentTabBar()
            }
            onboardingVC.modalPresentationStyle = .fullScreen
            onboardingVC.modalTransitionStyle = .crossDissolve
            present(onboardingVC, animated: true)
        }
    }
    
    private func presentTabBar() {
        let tabBar = TabBarViewController()
        tabBar.modalPresentationStyle = .fullScreen
        tabBar.modalTransitionStyle = .crossDissolve
        present(tabBar, animated: true, completion: nil)
    }
    
    private func fetchData() {
        guard let currentLanguage = Locale.current.language.languageCode?.identifier,
              let dataLanguage = DataLanguage(rawValue: currentLanguage) else { return }
        
        // Try to load from cache first
        if let cachedCategories = CacheService.shared.loadCategories(for: dataLanguage) {
            StorageService.shared.categories = cachedCategories
            print("✅ Loaded categories from cache")
        }
        
        if let cachedIdeas = CacheService.shared.loadIdeas(for: dataLanguage) {
            StorageService.shared.ideas = cachedIdeas
            print("✅ Loaded ideas from cache")
        }
        
        // Try to load from Firebase (will update cache if successful)
        firebaseService.getCategories(with: dataLanguage) { result in
            switch result {
            case .success(let categories):
                StorageService.shared.categories = categories
                // Update cache with fresh data
                CacheService.shared.saveCategories(categories, for: dataLanguage)
            case .failure(let error):
                print("Load categories with error: \(error)")
                // If we have cached data, it's already loaded above
            }
        }
        
        firebaseService.getIdeas(with: dataLanguage) { result in
            switch result {
            case .success(let ideas):
                StorageService.shared.ideas = ideas
                // Update cache with fresh data
                CacheService.shared.saveIdeas(ideas, for: dataLanguage)
            case .failure(let error):
                print("Load ideas with error: \(error)")
                // If we have cached data, it's already loaded above
            }
        }
        
        // Настройка локальных пушей: грузим с Firebase при первом запуске или используем кеш
        NotificationService.shared.setupNotificationsOnFirstLaunch(with: dataLanguage) { _ in }
    }
}
