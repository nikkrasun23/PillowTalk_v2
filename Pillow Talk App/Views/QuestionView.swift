//
//  QuestionView.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import UIKit

final class QuestionView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "RussoOne-Regular", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Commissioner-Regular", size: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        addShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShadowPath()
    }
    
    func setup(with model: CardViewModel) {
        textLabel.text = model.title
        imageView.image = UIImage(named: "character\(Int.random(in: 1...14))")
        
        switch model.type {
        case .question:
            titleLabel.textColor = UIColor(hex: "#F99F4F")
            titleLabel.text = "Питання"
        case .idea:
            titleLabel.textColor = UIColor(hex: "#DB5A3D")
            titleLabel.text = "Ідеї"
        case .action:
            titleLabel.textColor = UIColor(hex: "#80B6BC")
            titleLabel.text = "Дія"
        }
    }
}

private extension QuestionView {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 140),
        ])
        
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 15
        layer.masksToBounds = false
        
        updateShadowPath()
    }
        
    func updateShadowPath() {
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: layer.cornerRadius
        ).cgPath
    }
}
