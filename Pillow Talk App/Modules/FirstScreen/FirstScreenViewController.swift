//
//  FirstScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import UIKit
import RevenueCat
import RevenueCatUI

class FirstScreenViewController: UIViewController {
    
    private let firebaseService: FirebaseService = FirebaseService()
    
    var firstScreenView: FirstScreenView!

    override func loadView() {

        firstScreenView = FirstScreenView(frame: UIScreen.main.bounds)
        self.view = firstScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        setupStartGameButtonAction()
        fetchData()
        
        IAPManager.shared.fetchSubscribtionStatus()
    }

    private func setupStartGameButtonAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startGameButtonTapped))
        firstScreenView.startGameButton.addGestureRecognizer(tapGesture)
        firstScreenView.startGameButton.isUserInteractionEnabled = true
    }

    @objc private func startGameButtonTapped() {
//        let tabBar = TabBarViewController()
//        tabBar.modalPresentationStyle = .fullScreen
//        tabBar.modalTransitionStyle = .crossDissolve
//        present(tabBar, animated: true, completion: nil)
        
        
        
        let controller = PaywallViewController()
        controller.delegate = self

        present(controller, animated: true, completion: nil)
    }
    
    func fetchData() {
        let language = "UA"
        
        firebaseService.getCategories(with: language) { result in
            switch result {
            case .success(let categories):
                StorageService.shared.categories = categories
            case .failure(let error):
                print("Load categories with error: \(error)")
            }
        }
        
        firebaseService.getIdeas(with: language) { result in
            switch result {
            case .success(let ideas):
                StorageService.shared.ideas = ideas
            case .failure(let error):
                print("Load ideas with error: \(error)")
            }
        }
    }
}

extension FirstScreenViewController: PaywallViewControllerDelegate {

    func paywallViewController(_ controller: PaywallViewController,
                               didFinishPurchasingWith customerInfo: CustomerInfo) {

    }

}
