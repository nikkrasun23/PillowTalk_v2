//
//  SplashScreenView.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 25.12.2024.
//

import Foundation
import UIKit

class SplashScreenView: UIView {
    
    // Константы
    
    // MARK: - Title
    
    let pillowText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "RussoOne-Regular", size: 56)
        text.textColor = UIColor(hex: "#F99F4F")
        text.textAlignment = .center
        text.text = "pillow"
        return text
    }()
    
    let talkText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "RussoOne-Regular", size: 56)
        text.textColor = UIColor(hex: "#80B6BC")
        text.textAlignment = .center
        text.text = "talk"
        return text
    }()
    
    // MARK: - Line Image
    
    let lineImage: UIImageView = {
        let line = UIImageView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.image = .lineSplashScreen
        return line
    }()
    
    // MARK: - Plants
    
    let beigePlant1: UIImageView = {
        let plantImage = UIImageView()
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.image = .beigePlant
        return plantImage
    }()
    
    let orangePlant1: UIImageView = {
        let plantImage = UIImageView()
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.image = .orangePlant3
        return plantImage
    }()
    
    // MARK: - Characters
    
    let charactersImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .hugs
        return image
    }()
    
    
    // MARK: -

    override init(frame: CGRect) {

        super.init(frame: frame)
        setupSplashScreenView()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupSplashScreenView()
    }
    
    private func setupUI() {
        addSubview(lineImage)
        addSubview(beigePlant1)
        addSubview(orangePlant1)
        addSubview(pillowText)
        addSubview(talkText)
        addSubview(charactersImage)
        
        NSLayoutConstraint.activate([
            
            pillowText.widthAnchor.constraint(equalToConstant: 176),
            pillowText.heightAnchor.constraint(equalToConstant: 67),
            pillowText.topAnchor.constraint(equalTo: topAnchor, constant: 298),
            pillowText.leftAnchor.constraint(equalTo: leftAnchor, constant: 109),
            
            talkText.widthAnchor.constraint(equalToConstant: 110),
            talkText.heightAnchor.constraint(equalToConstant: 67),
            talkText.topAnchor.constraint(equalTo: topAnchor, constant: 365),
            talkText.leftAnchor.constraint(equalTo: leftAnchor, constant: 142),
            
            beigePlant1.widthAnchor.constraint(equalToConstant: 176),
            beigePlant1.heightAnchor.constraint(equalToConstant: 359),
            beigePlant1.topAnchor.constraint(equalTo: topAnchor, constant: 309),
            beigePlant1.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            
            orangePlant1.widthAnchor.constraint(equalToConstant: 173),
            orangePlant1.heightAnchor.constraint(equalToConstant: 194),
            orangePlant1.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            orangePlant1.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            
            lineImage.widthAnchor.constraint(equalToConstant: 371),
            lineImage.heightAnchor.constraint(equalToConstant: 792),
            lineImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//            lineImage.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            lineImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            
            charactersImage.widthAnchor.constraint(equalToConstant: 350),
            charactersImage.heightAnchor.constraint(equalToConstant: 250),
            charactersImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            charactersImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 22)
        ])
    }
    
    private func setupIllustrationVisibility() {
        // Проверяем высоту экрана
        let screenHeight = UIScreen.main.bounds.height
        
        // Скрываем иллюстрацию, если высота экрана меньше или равна 667 (например, iPhone SE, 6, 7)
        if screenHeight <= 667 {
            charactersImage.isHidden = true // Скрываем вашу иллюстрацию
        } else {
            charactersImage.isHidden = false // Показываем иллюстрацию для больших экранов
        }
    }
    
    // MARK: - Setup UI
    
    private func setupSplashScreenView() {
        setupUI()
        setupIllustrationVisibility()
    }
}

    



