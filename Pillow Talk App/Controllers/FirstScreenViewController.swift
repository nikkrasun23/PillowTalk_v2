//
//  FirstScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    var firstScreenView: FirstScreenView!

    override func loadView() {

        firstScreenView = FirstScreenView(frame: UIScreen.main.bounds)
        self.view = firstScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        setupStartGameButtonAction()
    }

    private func setupStartGameButtonAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startGameButtonTapped))
        firstScreenView.startGameButton.addGestureRecognizer(tapGesture)
        firstScreenView.startGameButton.isUserInteractionEnabled = true
    }

    @objc private func startGameButtonTapped() {
        let questionScreenVC = QuestionScreenViewController()
        questionScreenVC.modalPresentationStyle = .fullScreen
        present(questionScreenVC, animated: true, completion: nil)
    }
}
