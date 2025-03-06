//
//  ScrollElement.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 19.02.2025.
//

import Foundation
import UIKit

class ScrollElement: UIView {
    
    let shapeView: UIView = {
        let shape = UIView()
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.backgroundColor = .white
        shape.layer.cornerRadius = 10
        return shape
    }()
    
    let iconForShapeView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .shapeThirdBlack
        return image
    }()
    
    let textForShapeView: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .black
        text.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.12 / 14 // Учитываем line-height из Figma

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Commissioner-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
//            .foregroundColor: UIColor(hex: "#DB5A3D"),
            .paragraphStyle: paragraphStyle
        ]

        text.attributedText = NSAttributedString(string: "Легке знайомство", attributes: attributes)
        return text
    }()
    
    init(image: UIImage, text: String, color: UIColor) {
        super.init(frame: .zero)
        setupUI()
        
        iconForShapeView.image = image
        textForShapeView.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTapGesture(target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func updateState(isSelected: Bool, selectedIcon: UIImage, defaultIcon: UIImage, selectedColor: UIColor, defaultColor: UIColor) {
        iconForShapeView.image = isSelected ? selectedIcon : defaultIcon
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 17.12 / 14

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Commissioner-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: isSelected ? selectedColor : defaultColor,
            .paragraphStyle: paragraphStyle
        ]

        textForShapeView.attributedText = NSAttributedString(string: textForShapeView.text ?? "", attributes: attributes)
    }
    
    func setupUI() {
        
        addSubview(shapeView)
        shapeView.addSubview(iconForShapeView)
        shapeView.addSubview(textForShapeView)
        
        NSLayoutConstraint.activate([
            
            shapeView.heightAnchor.constraint(equalToConstant: 40),
            shapeView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            shapeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            shapeView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            shapeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            iconForShapeView.widthAnchor.constraint(equalToConstant: 24),
            iconForShapeView.heightAnchor.constraint(equalToConstant: 24),
            iconForShapeView.leftAnchor.constraint(equalTo: shapeView.leftAnchor, constant: 8),
            iconForShapeView.topAnchor.constraint(equalTo: shapeView.topAnchor, constant: 8),
            
            textForShapeView.heightAnchor.constraint(equalToConstant: 17),
            textForShapeView.leftAnchor.constraint(equalTo: iconForShapeView.rightAnchor, constant: 8),
            textForShapeView.topAnchor.constraint(equalTo: shapeView.topAnchor, constant: 8.5),
            
        ])
        
    }
}

