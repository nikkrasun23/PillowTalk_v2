//
//  OnboardingCollectionViewCell.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: OnboardingCollectionViewCell.self)
    
    // MARK: - UI Elements
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Commissioner-SemiBold", size: 32)
        label.textColor = UIColor(hex: "#33363F")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Commissioner-Regular", size: 20)
        label.textColor = UIColor(hex: "#33363F")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    
    private var pageModel: OnboardingPageModel?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with model: OnboardingPageModel) {
        self.pageModel = model
        
        characterImageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - Private Methods

private extension OnboardingCollectionViewCell {
    func setupUI() {
        addSubview(characterImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Character Image
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            characterImageView.widthAnchor.constraint(equalToConstant: 345),
            characterImageView.heightAnchor.constraint(equalToConstant: 390),
            
            // Title (под контейнером)
            titleLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -40)
        ])
    }
    
}
