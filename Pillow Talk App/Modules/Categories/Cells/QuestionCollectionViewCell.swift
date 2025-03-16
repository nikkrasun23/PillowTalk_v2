//
//  QuestionCollectionViewCell.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 12/03/2025.
//

import UIKit

final class QuestionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "QuestionCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "RussoOne-Regular", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Commissioner-Regular", size: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#33363F")
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    func set(model: CardViewModel) {
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

private extension QuestionCollectionViewCell {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 14),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 14),
            textLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -14),
            
            imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 140),
        ])
        
        backgroundColor = .clear
    }
    
    func addShadow() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 15
        containerView.layer.masksToBounds = false
        
        updateShadowPath()
    }
        
    func updateShadowPath() {
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: containerView.layer.cornerRadius
        ).cgPath
    }
}
