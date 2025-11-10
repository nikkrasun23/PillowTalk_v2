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
        
        firebaseService.getCategories(with: dataLanguage) { result in
            switch result {
            case .success(let categories):
                StorageService.shared.categories = categories
            case .failure(let error):
                print("Load categories with error: \(error)")
            }
        }
        
        firebaseService.getIdeas(with: dataLanguage) { result in
            switch result {
            case .success(let ideas):
                StorageService.shared.ideas = ideas
            case .failure(let error):
                print("Load ideas with error: \(error)")
            }
        }
        
        // Настройка локальных пушей: грузим с Firebase при первом запуске или используем кеш
        NotificationService.shared.setupNotificationsOnFirstLaunch(with: dataLanguage) { _ in }
    }
}
