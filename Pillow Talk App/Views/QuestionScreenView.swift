//
//  QuestionScreenView.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import Foundation
import UIKit

class QuestionScreenView: UIView {
    
    // Константы
    
    
    // MARK: - Plant Image
    
    let greenPlantImage: UIImageView = {
        let plantImage = UIImageView()
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.image = .greenPlant
        return plantImage
    }()
    
    let orangePlantImage: UIImageView = {
        let plantImage = UIImageView()
        plantImage.translatesAutoresizingMaskIntoConstraints = false
        plantImage.image = .orangePlant
        return plantImage
    }()
    
    // MARK: - Question Card
    
    var questionCardView: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 10
        card.backgroundColor = .white
        card.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        card.layer.shadowOpacity = 0.1 // Прозрачность тени (от 0 до 1)
        card.layer.shadowOffset = CGSize(width: 0, height: 4) // Смещение тени
        card.layer.shadowRadius = 8
        return card
    }()
    
    let labelQuestionOrAction: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#F99F4F")
        label.font = UIFont(name: "RussoOne-Regular", size: 32)
        label.textAlignment = .left
        label.text = "Питання"
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Свайпни картку вправо, щоб тут почали зʼявлятися питання. Задавайте їх одне одному з вашим партнером!"
        return label
    }()
    
    // MARK: - Next Card View
    
    var nextCardView: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 10
        card.backgroundColor = .white
        card.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        card.layer.shadowOpacity = 0.1 // Прозрачность тени (от 0 до 1)
        card.layer.shadowOffset = CGSize(width: 0, height: 4) // Смещение тени
        card.layer.shadowRadius = 8
        return card
    }()
    
    // MARK: - ScrollView
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    // MARK: - StackView
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
//        stack.alignment = .fill
//        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Легке знайомство
    
    let shapeOne: UIView = {
        let shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 10
        return shape
    }()
    
    let iconForShapeOne: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .shapeOneIconRed
        return image
    }()
    
    let textForShapeOne: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.12 / 14 // Учитываем line-height из Figma

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Commissioner-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor(hex: "#DB5A3D"),
            .paragraphStyle: paragraphStyle
        ]

        text.attributedText = NSAttributedString(string: "Легке знайомство", attributes: attributes)
        return text
    }()
    
    // MARK: - Глибокий звʼязок
    
    let shapeSecond: UIView = {
        let shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 10
        return shape
    }()
    
    let iconForSecondShape: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .shapeSecondBlack
        return image
    }()
    
    let textForShapeSecond: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.textColor = .black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.12 / 14 // Учитываем line-height из Figma

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Commissioner-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
            .paragraphStyle: paragraphStyle
        ]

        text.attributedText = NSAttributedString(string: "Глибокий звʼязок", attributes: attributes)
        return text
    }()
    
    // MARK: - Разом крізь труднощі
    
    let shapeThird: UIView = {
        let shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 10
        return shape
    }()
    
    let iconForThirdShape: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .shapeThirdBlack
        return image
    }()
    
    let textForThirdShape: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.textColor = .black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.12 / 14 // Учитываем line-height из Figma

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Commissioner-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
            .paragraphStyle: paragraphStyle
        ]

        text.attributedText = NSAttributedString(string: "Разом крізь труднощі", attributes: attributes)
        return text
    }()
    
    // MARK: - Bottom Bar
    
    // Tap View
    
    let tapViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tapViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tapViewThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Elements
    
    let categoryIcon: UIImageView = {
        
        let navigation1 = UIImageView()
        navigation1.translatesAutoresizingMaskIntoConstraints = false
        navigation1.image = .categoryIconBlue
        return navigation1
    }()
    
    let categoryText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.textAlignment = .center
        text.textColor = UIColor(hex: "#33363F")
        text.text = "Категорії \nпитань"
        text.font = UIFont(name: "Commissioner-Regular", size: 14)
        return text
    }()
    
    let datingCup: UIImageView = {
        
        let datingImage = UIImageView()
        datingImage.translatesAutoresizingMaskIntoConstraints = false
        datingImage.image = .cupBlue
        return datingImage
    }()
    
    let datingText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.textAlignment = .center
        text.textColor = UIColor(hex: "#33363F")
        text.text = "Банка \nпобачень"
        text.font = UIFont(name: "Commissioner-Regular", size: 14)
        return text
    }()
    
    let settingsIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .settingsBlue
        return image
    }()
    
    let textForSettings: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "Commissioner-Regular", size: 14)
        text.text = "Профіль"
        text.numberOfLines = 0
        text.textAlignment = .center
        return text
    }()
    
    
    let bottomView: UIView = {
        let whiteBottom = UIView()
        whiteBottom.translatesAutoresizingMaskIntoConstraints = false
        whiteBottom.backgroundColor = .white
        
        whiteBottom.layer.shadowColor = UIColor.black.cgColor // Цвет тени (черный)
        whiteBottom.layer.shadowOpacity = 0.3 // Прозрачность тени (0.0 — невидима, 1.0 — полностью непрозрачна)
        whiteBottom.layer.shadowOffset = CGSize(width: 0, height: 2) // Смещение тени (ширина, высота)
        whiteBottom.layer.shadowRadius = 3
        return whiteBottom
    }()
    
    
    // MARK: - Character for Card
    
    var character1: UIImage = .character1
    var character2: UIImage = .character2
    let characterArray: [UIImage] = [.character1, .character2, .character3, .character4, .character5, .character6, .character7, .character8, .character9, .character10, .character11, .character12, .character13, .character14]
    
    let characterForCard = UIImageView()
    
    func updateCharacterImage() {
        characterForCard.image = characterArray.randomElement()
    }
    
    private func setupCharacterForCard() {
        characterForCard.image = characterArray.randomElement()
        characterForCard.translatesAutoresizingMaskIntoConstraints = false
        questionCardView.addSubview(characterForCard)
        
        NSLayoutConstraint.activate([
            characterForCard.widthAnchor.constraint(equalToConstant: 140),
            characterForCard.heightAnchor.constraint(equalToConstant: 220),
            characterForCard.bottomAnchor.constraint(equalTo: questionCardView.bottomAnchor, constant: 0),
            characterForCard.rightAnchor.constraint(equalTo: questionCardView.rightAnchor, constant: 0)
        ])
    }
    
    // MARK: - Settings
    
    
    
    // MARK: BG
    
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        view.layer.shadowOpacity = 0.1 // Прозрачность тени (от 0 до 1)
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // Смещение тени
        view.layer.shadowRadius = 8
        return view
    }()
    
   
    
    // MARK: - Setup UI
    

    override init(frame: CGRect) {

        super.init(frame: frame)
        setupQuestionScreenUI()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupQuestionScreenUI()
    }
    
    private func setupUI() {
        
        addSubview(greenPlantImage)
        addSubview(orangePlantImage)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        addSubview(questionCardView)
        questionCardView.addSubview(labelQuestionOrAction)
        questionCardView.addSubview(questionLabel)
        addSubview(bottomView)
        bottomView.addSubview(tapViewOne)
        bottomView.addSubview(tapViewTwo)
        bottomView.addSubview(tapViewThree)
        bottomView.addSubview(categoryIcon)
        bottomView.addSubview(categoryText)
        bottomView.addSubview(datingCup)
        bottomView.addSubview(datingText)
        bottomView.addSubview(settingsIcon)
        bottomView.addSubview(textForSettings)
        
        // MARK: - Settings Screen addSubview
        
        addSubview(bgView)
//
        // MARK: - NSLayoutConstraint
        
        NSLayoutConstraint.activate([
        
        greenPlantImage.widthAnchor.constraint(equalToConstant: 227),
        greenPlantImage.heightAnchor.constraint(equalToConstant: 224),
        greenPlantImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        greenPlantImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        
        orangePlantImage.widthAnchor.constraint(equalToConstant: 275),
        orangePlantImage.heightAnchor.constraint(equalToConstant: 284),
        orangePlantImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        orangePlantImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
        
//      nextCardView.widthAnchor.constraint(equalToConstant: 300),
//      nextCardView.heightAnchor.constraint(equalToConstant: 420),
//      nextCardView.leftAnchor.constraint(equalTo: leftAnchor, constant: 47),
//      nextCardView.topAnchor.constraint(equalTo: topAnchor, constant: 216),
        
        questionCardView.widthAnchor.constraint(equalToConstant: 300),
        questionCardView.heightAnchor.constraint(equalToConstant: 420),
//        questionCardView.leftAnchor.constraint(equalTo: leftAnchor, constant: 47),
//        questionCardView.topAnchor.constraint(equalTo: topAnchor, constant: 148),
        
        labelQuestionOrAction.widthAnchor.constraint(equalToConstant: 141),
        labelQuestionOrAction.heightAnchor.constraint(equalToConstant: 39),
        labelQuestionOrAction.topAnchor.constraint(equalTo: questionCardView.topAnchor, constant: 32),
        labelQuestionOrAction.leadingAnchor.constraint(equalTo: questionCardView.leadingAnchor, constant: 26),
        
        questionLabel.widthAnchor.constraint(equalToConstant: 248),
        questionLabel.heightAnchor.constraint(equalToConstant: 116),
        questionLabel.topAnchor.constraint(equalTo: questionCardView.topAnchor, constant: 87),
        questionLabel.leftAnchor.constraint(equalTo: questionCardView.leftAnchor, constant: 26),
        
        bottomView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        bottomView.heightAnchor.constraint(equalToConstant: 108),
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        bottomView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
        
        tapViewOne.widthAnchor.constraint(equalToConstant: 100),
        tapViewOne.heightAnchor.constraint(equalToConstant: 84),
        tapViewOne.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 32),
        tapViewOne.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        
        tapViewTwo.widthAnchor.constraint(equalToConstant: 100),
        tapViewTwo.heightAnchor.constraint(equalToConstant: 84),
        tapViewTwo.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 146.5),
        tapViewTwo.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        
        tapViewThree.widthAnchor.constraint(equalToConstant: 100),
        tapViewThree.heightAnchor.constraint(equalToConstant: 84),
        tapViewThree.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        tapViewThree.leftAnchor.constraint(equalTo: leftAnchor, constant: 261),
        
        categoryIcon.widthAnchor.constraint(equalToConstant: 32),
        categoryIcon.heightAnchor.constraint(equalToConstant: 32),
        categoryIcon.topAnchor.constraint(equalTo: tapViewOne.topAnchor, constant: 10),
        categoryIcon.leftAnchor.constraint(equalTo: tapViewOne.leftAnchor, constant: 34),
        
//        categoryText.widthAnchor.constraint(lessThanOrEqualToConstant: 64),
//        categoryText.heightAnchor.constraint(equalToConstant: 34),
        categoryText.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 4),
        categoryText.leftAnchor.constraint(equalTo: tapViewOne.leftAnchor, constant: 18),
        
        datingCup.widthAnchor.constraint(equalToConstant: 32),
        datingCup.heightAnchor.constraint(equalToConstant: 32),
        datingCup.leftAnchor.constraint(equalTo: tapViewTwo.leftAnchor, constant: 34.5),
        datingCup.topAnchor.constraint(equalTo: tapViewTwo.topAnchor, constant: 10),
        
        datingText.topAnchor.constraint(equalTo: datingCup.bottomAnchor, constant: 4),
        datingText.leftAnchor.constraint(equalTo: tapViewTwo.leftAnchor, constant: 19),
        
        settingsIcon.widthAnchor.constraint(equalToConstant: 32),
        settingsIcon.heightAnchor.constraint(equalToConstant: 32),
        settingsIcon.topAnchor.constraint(equalTo: tapViewThree.topAnchor, constant: 10),
        settingsIcon.leftAnchor.constraint(equalTo: tapViewThree.leftAnchor, constant: 34),
        
        textForSettings.topAnchor.constraint(equalTo: settingsIcon.bottomAnchor, constant: 4),
        textForSettings.leftAnchor.constraint(equalTo: tapViewThree.leftAnchor, constant: 22),
        
        // MARK: - Settings Screem Layout
        
        bgView.widthAnchor.constraint(equalToConstant: 345),
        bgView.heightAnchor.constraint(equalToConstant: 392),
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 153),
        bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
        
        
        
        // MARK: -
        
        scrollView.heightAnchor.constraint(equalToConstant: 40),
        scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
        scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -16),
        
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
        
        
        ])
    }
    
    private func setupSizeForSmallScreen() {
        
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 667 { // Для iPhone SE, 6, 7
                NSLayoutConstraint.activate([
                    questionCardView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    questionCardView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            } else { // Стандартное положение для больших экранов
                NSLayoutConstraint.activate([
                    questionCardView.topAnchor.constraint(equalTo: topAnchor, constant: 148),
                    questionCardView.leftAnchor.constraint(equalTo: leftAnchor, constant: 47)
                ])
        }
    }
    
//    func setupScrollElements() {
//        
////        stackView.backgroundColor = .white
//        
//        let scrollElement1 = ScrollElement(image: .shapeOneIconBlack, text: "Легке знайомство", color: .black)
//        let scrollElement2 = ScrollElement(image: .shapeSecondBlack, text: "Глибокий звʼязок", color: .black)
//        let scrollElement3 = ScrollElement(image: .shapeThirdBlack, text: "Разом крізь труднощі", color: .black)
//        
//        scrollElement1.widthAnchor.constraint(equalToConstant: 168).isActive = true
//        scrollElement2.widthAnchor.constraint(equalToConstant: 164).isActive = true
//        scrollElement3.widthAnchor.constraint(equalToConstant: 192).isActive = true
//        
//        stackView.addArrangedSubview(scrollElement1)
//        stackView.addArrangedSubview(scrollElement2)
//        stackView.addArrangedSubview(scrollElement3)
//        
////        [scrollElement1, scrollElement2, scrollElement3].forEach { element in
////            stackView.addArrangedSubview(element)
////        }
//    }
    
    func setupScrollElements() {
        let scrollElement1 = ScrollElement(image: .shapeOneIconBlack, text: "Легке знайомство", color: .black)
        let scrollElement2 = ScrollElement(image: .shapeSecondBlack, text: "Глибокий звʼязок", color: .black)
        let scrollElement3 = ScrollElement(image: .shapeThirdBlack, text: "Разом крізь труднощі", color: .black)
        
        // Встановлюємо ширину для елементів
        scrollElement1.widthAnchor.constraint(equalToConstant: 168).isActive = true
        scrollElement2.widthAnchor.constraint(equalToConstant: 164).isActive = true
        scrollElement3.widthAnchor.constraint(equalToConstant: 192).isActive = true
        
        // Додаємо елементи до stackView з кастомним відступом для першого елемента
        stackView.addArrangedSubview(scrollElement1)
        stackView.addArrangedSubview(scrollElement2)
        stackView.addArrangedSubview(scrollElement3)
        
        // Додаємо відступ для першого елемента (scrollElement1)
        if let firstElement = stackView.arrangedSubviews.first {
            firstElement.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        }
    }
    
    private func setupQuestionScreenUI() {
        setupUI()
        setupSizeForSmallScreen()
        setupCharacterForCard()
        setupScrollElements()
    }
}

