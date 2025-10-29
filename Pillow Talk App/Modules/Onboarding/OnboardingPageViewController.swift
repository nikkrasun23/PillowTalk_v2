//
//  OnboardingPageViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
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
    
    init(pageModel: OnboardingPageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
}

// MARK: - Private Methods

private extension OnboardingPageViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        view.addSubview(characterImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Character Image
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.widthAnchor.constraint(equalToConstant: 345),
            characterImageView.heightAnchor.constraint(equalToConstant: 390),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    func configure() {
        guard let model = pageModel else { return }
        
        characterImageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
