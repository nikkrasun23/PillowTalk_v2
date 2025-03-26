//
//  SplashScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 25.12.2024.
//

import UIKit

class SplashScreenViewController: UIViewController {
    var splashScreenView: SplashScreenView!

    override func loadView() {
        // Инициализируем кастомный SplashScreenView
        splashScreenView = SplashScreenView(frame: UIScreen.main.bounds)
        self.view = splashScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        // Добавляем задержку и переход на следующий экран
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToFirstScreen()
        }
    }

    private func navigateToFirstScreen() {
        IAPManager.shared.fetchSubscribtionStatus()
        
        let firstScreenVC = FirstScreenViewController()
        firstScreenVC.modalPresentationStyle = .fullScreen
        firstScreenVC.modalTransitionStyle = .crossDissolve
        self.present(firstScreenVC, animated: true, completion: nil)
    }
}
