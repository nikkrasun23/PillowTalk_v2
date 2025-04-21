//
//  FirstScreenView.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import Foundation
import UIKit

class FirstScreenView: UIView {
    
    // Переменные
    let labelForStartGameButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = /*"Почати"*/ NSLocalizedString("startButton", comment: "")
        label.font = UIFont(name: "RussoOne-Regular", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let startGameButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#DB5A3D")
        view.layer.cornerRadius = 8
        return view
    }()
    
    let callToActionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Commissioner-Regular", size: 20)
        label.textColor = UIColor(hex: "#33363F")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = /*"Відкривайтеся, спілкуйтеся та зближуйтеся ще більше!"*/ NSLocalizedString("onboardingSubtitle", comment: "")
        return label
    }()
    
    let titleForStartScreen: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "RussoOne-Regular", size: 28)
        label.textColor = UIColor(hex: "#33363F")
        label.numberOfLines = 0
        label.text = /*"Готові до теплого спілкування?"*/ NSLocalizedString("onboardingTitle", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Red Line
    
    let lineImage: UIImageView = {
        let line = UIImageView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.image = .lineFirstScreen
        return line
    }()
    
    // MARK: - Green Plant
    
    let greenPlant: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .greenPlant3
        return imageView
    }()
    
    // MARK: - Characters for Start Screen
    
    let characterOrange: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .characterForStartScreen1
        return imageView
        
    }()
    
    // MARK: - Second characters for Start Screen
    
    let characterSecond: UIImageView = {
        let character2 = UIImageView()
        character2.translatesAutoresizingMaskIntoConstraints = false
        character2.image = .characterForStartScreen2
        return character2
    }()
    
    // MARK: - Bubbles
    
    let bubbles: UIImageView = {
        let bubble1 = UIImageView()
        bubble1.translatesAutoresizingMaskIntoConstraints = false
        return bubble1
    }()
    
    //
    
    override init(frame: CGRect) {
        // Инициализация коэффициентов масштабирования
//        self.scaleFactorWidth = screenWidth / 393.0
//        self.scaleFactorHeight = screenHeight / 852.0
        super.init(frame: frame)
        setupFirstScreenUI()
    }
    
    required init?(coder: NSCoder) {
        // Инициализация коэффициентов масштабирования
//        self.scaleFactorWidth = screenWidth / 393.0
//        self.scaleFactorHeight = screenHeight / 852.0
        
        super.init(coder: coder)
        setupFirstScreenUI()
    }
    
    // MARK: - Setup UI
    
    private func setupFirstScreenUI() {
        setupUI()
        setupTitleForStartScreen()
    }
    
    func setupUI() {
        addSubview(lineImage)
        startGameButton.addSubview(labelForStartGameButton)
        addSubview(greenPlant)
        addSubview(callToActionText)
        addSubview(characterOrange)
        addSubview(characterSecond)
        addSubview(startGameButton)
        addSubview(titleForStartScreen)
        addSubview(bubbles)
        
        
        NSLayoutConstraint.activate([
            
            startGameButton.heightAnchor.constraint(equalToConstant: 60),
            startGameButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            startGameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            startGameButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            labelForStartGameButton.topAnchor.constraint(equalTo: startGameButton.topAnchor, constant: 10),
            labelForStartGameButton.leftAnchor.constraint(equalTo: startGameButton.leftAnchor, constant: 10),
            labelForStartGameButton.rightAnchor.constraint(equalTo: startGameButton.rightAnchor, constant: -10),
            labelForStartGameButton.bottomAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: -10),
            
            greenPlant.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            greenPlant.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            greenPlant.widthAnchor.constraint(equalToConstant: 173),
            greenPlant.heightAnchor.constraint(equalToConstant: 194),
            
            callToActionText.bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -16),
            callToActionText.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            callToActionText.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            
            titleForStartScreen.topAnchor.constraint(equalTo: topAnchor, constant: 220),
            titleForStartScreen.widthAnchor.constraint(equalToConstant: 270),
            titleForStartScreen.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            characterOrange.topAnchor.constraint(equalTo: titleForStartScreen.bottomAnchor, constant: 2),
            characterOrange.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            characterOrange.widthAnchor.constraint(equalToConstant: 71),
            characterOrange.heightAnchor.constraint(equalToConstant: 249),
            
            characterSecond.topAnchor.constraint(equalTo: titleForStartScreen.bottomAnchor, constant: 190),
            characterSecond.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            characterSecond.widthAnchor.constraint(equalToConstant: 80),
            characterSecond.heightAnchor.constraint(equalToConstant: 215),
            
            lineImage.widthAnchor.constraint(equalToConstant: 393),
            lineImage.heightAnchor.constraint(equalToConstant: 300),
            lineImage.topAnchor.constraint(equalTo: titleForStartScreen.bottomAnchor, constant: 27),
            lineImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            
            bubbles.widthAnchor.constraint(equalToConstant: 210),
            bubbles.heightAnchor.constraint(equalToConstant: 200),
            bubbles.topAnchor.constraint(equalTo: titleForStartScreen.bottomAnchor, constant: 94),
            bubbles.leftAnchor.constraint(equalTo: leftAnchor, constant: 92)
        ])
        
        let currentLanguage = Locale.current.language.languageCode?.identifier
        bubbles.image = UIImage(named: "bubbles_\(currentLanguage ?? "en")")
    }
    
    private func setupTitleForStartScreen() {
        self.addSubview(titleForStartScreen)
        
        // Определяем высоту экрана
        let screenHeight = UIScreen.main.bounds.height
        var topOffset: CGFloat = 220 // Значение по умолчанию для больших экранов
        
        // Если высота экрана соответствует iPhone SE (3rd Gen), уменьшаем отступ
        if screenHeight <= 667 { // Высота экрана iPhone SE
            topOffset = 120 // Смещение выше для SE
        }
        
        NSLayoutConstraint.activate([
            titleForStartScreen.topAnchor.constraint(equalTo: topAnchor, constant: topOffset),
            titleForStartScreen.widthAnchor.constraint(equalToConstant: 270),
            titleForStartScreen.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
