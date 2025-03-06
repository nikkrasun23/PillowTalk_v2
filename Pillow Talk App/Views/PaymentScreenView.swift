//
//  PaymentScreenView.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 11.12.2024.
//

import Foundation
import UIKit

class PaymentScreenView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    // Коэффициенты масштабирования
    private let scaleFactorWidth: CGFloat
    private let scaleFactorHeight: CGFloat
    
    override init(frame: CGRect) {
        // Инициализация коэффициентов масштабирования
        self.scaleFactorWidth = screenWidth / 393.0
        self.scaleFactorHeight = screenHeight / 852.0
        super.init(frame: frame)
        setupPaymentScreenUI()
    }
    
    required init?(coder: NSCoder) {
        // Инициализация коэффициентов масштабирования
        self.scaleFactorWidth = screenWidth / 393.0
        self.scaleFactorHeight = screenHeight / 852.0
        
        super.init(coder: coder)
        setupPaymentScreenUI()
    }
    
    private func setupPaymentScreenUI() {
        setupLine()
        setupWhiteView()
        setupSubscriptionButton()
        setupSubscriptionLabelForButton()
        setupSubscriptionLabel()
        setupHugsImage()
        setupDescriptionLabel()
        setupBeigePlant()
        setupGreenPlant()

    }
    
    // MARK: - White View
    
    let whiteView = UIView()
    
    private func setupWhiteView() {
        whiteView.backgroundColor = .white
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.layer.cornerRadius = 20
        self.addSubview(whiteView)
        
        NSLayoutConstraint.activate([
            whiteView.widthAnchor.constraint(equalToConstant: 393 * scaleFactorWidth),
            whiteView.heightAnchor.constraint(equalToConstant: 263 * scaleFactorHeight),
            whiteView.topAnchor.constraint(equalTo: self.topAnchor, constant: 589 * scaleFactorHeight),
            whiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0 * scaleFactorWidth)
        ])
    }
    // MARK: - Line
    
    let lineImage = UIImageView()
    
    private func setupLine() {
        lineImage.translatesAutoresizingMaskIntoConstraints = false
        lineImage.image = .linePaymentScreen
        self.addSubview(lineImage)
        
        NSLayoutConstraint.activate([
            lineImage.widthAnchor.constraint(equalToConstant: 367 * scaleFactorWidth),
            lineImage.heightAnchor.constraint(equalToConstant: 590 * scaleFactorHeight),
            lineImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 * scaleFactorHeight),
            lineImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26 * scaleFactorWidth)
        ])
    }
    
    
    // MARK: - Plants
    
    let beigePlant = UIImageView()
    
    private func setupBeigePlant() {
        beigePlant.translatesAutoresizingMaskIntoConstraints = false
        beigePlant.image = .beigePlant2
        self.addSubview(beigePlant)
        
        NSLayoutConstraint.activate([
            beigePlant.widthAnchor.constraint(equalToConstant: 183 * scaleFactorWidth),
            beigePlant.heightAnchor.constraint(equalToConstant: 194 * scaleFactorHeight),
            beigePlant.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 * scaleFactorHeight),
            beigePlant.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 210 * scaleFactorWidth)
        ])
    }
    
    let greenPlant = UIImageView()
    
    private func setupGreenPlant() {
        greenPlant.translatesAutoresizingMaskIntoConstraints = false
        greenPlant.image = . greenPlant4
        self.addSubview(greenPlant)
        
        NSLayoutConstraint.activate([
            greenPlant.widthAnchor.constraint(equalToConstant: 153 * scaleFactorWidth),
            greenPlant.heightAnchor.constraint(equalToConstant: 312 * scaleFactorHeight),
            greenPlant.topAnchor.constraint(equalTo: self.topAnchor, constant: 54 * scaleFactorHeight),
            greenPlant.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0 * scaleFactorWidth)
        ])
    }
    
    // MARK: - Subscription Button
    
    let subscriptionButton = UIView()
    
    private func setupSubscriptionButton() {
        
        subscriptionButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionButton.backgroundColor = UIColor(hex: "#DB5A3D")
        subscriptionButton.layer.cornerRadius = 8
        whiteView.addSubview(subscriptionButton)
        
        NSLayoutConstraint.activate([
            subscriptionButton.widthAnchor.constraint(equalToConstant: 342 * scaleFactorWidth),
            subscriptionButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactorHeight),
            subscriptionButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 145 * scaleFactorHeight),
            subscriptionButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 24 * scaleFactorWidth)
        ])
    }
    
    let subscriptionLabelForButton = UILabel()
    
    private func setupSubscriptionLabelForButton() {
        
        subscriptionLabelForButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionLabelForButton.text = "Оформити 79,99 UAH"
        subscriptionLabelForButton.font = UIFont(name: "RussoOne-Regular", size: 20)
        subscriptionLabelForButton.textColor = .white
        subscriptionButton.addSubview(subscriptionLabelForButton)
        
        NSLayoutConstraint.activate([
            subscriptionLabelForButton.widthAnchor.constraint(equalToConstant: 217 * scaleFactorWidth),
            subscriptionLabelForButton.heightAnchor.constraint(equalToConstant: 24 * scaleFactorHeight),
            subscriptionLabelForButton.topAnchor.constraint(equalTo: subscriptionButton.topAnchor, constant: 18 * scaleFactorHeight),
            subscriptionLabelForButton.leadingAnchor.constraint(equalTo: subscriptionButton.leadingAnchor, constant: 52 * scaleFactorWidth)
        ])
    }
    
    // MARK: - Subscription Label
    
    let subscriptionLabel = UILabel()
    
    private func setupSubscriptionLabel() {
        subscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptionLabel.textColor = UIColor(hex: "#33363F")
        subscriptionLabel.font = UIFont(name: "RussoOne-Regular", size: 32)
        subscriptionLabel.text = "Підписка"
        whiteView.addSubview(subscriptionLabel)
        
        NSLayoutConstraint.activate([
            subscriptionLabel.widthAnchor.constraint(equalToConstant: 152 * scaleFactorWidth),
            subscriptionLabel.heightAnchor.constraint(equalToConstant: 39 * scaleFactorHeight),
            subscriptionLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 24 * scaleFactorHeight),
            subscriptionLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 24 * scaleFactorWidth)
        ])
    }
    
    let descriptionLabel = UILabel()
    
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = UIColor(hex: "#33363F")
        descriptionLabel.font = UIFont(name: "Commissioner-Regular", size: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Ця підписка відкриває безлімітну базу психологічних запитань для пар! Почніть зараз!"
        whiteView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(equalToConstant: 345 * scaleFactorWidth),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50 * scaleFactorHeight),
            descriptionLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 81 * scaleFactorHeight),
            descriptionLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 24 * scaleFactorWidth)
        ])
    }
    
    //
    
    let hugsImage = UIImageView()
    
    private func setupHugsImage() {
        hugsImage.translatesAutoresizingMaskIntoConstraints = false
        hugsImage.image = .hugs
        self.addSubview(hugsImage)
        
        NSLayoutConstraint.activate([
            hugsImage.widthAnchor.constraint(equalToConstant: 350 * scaleFactorWidth),
            hugsImage.heightAnchor.constraint(equalToConstant: 250 * scaleFactorHeight),
            hugsImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 340 * scaleFactorHeight),
            hugsImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22 * scaleFactorWidth)
        ])
    }
}
