//
//  TabView.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 06/03/2025.
//

import UIKit

struct TabViewModel {
    enum TabType: Int {
        case category
        case cup
        case profile
    }
    
    let title: String
    let image: UIImage
    let selectedImage: UIImage
    let tabType: TabType
    let onTap: () -> Void
}

final class TabView: UIView {
    let type: TabViewModel.TabType
    
    private let viewModel: TabViewModel
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 14)
        return label
    }()
   
    init(viewModel: TabViewModel) {
        self.viewModel = viewModel
        self.type = viewModel.tabType
        
        super.init(frame: .zero)
        
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelected(_ selected: Bool) {
        imageView.image = selected ? viewModel.selectedImage : viewModel.image
    }
}

private extension TabView {
    func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap() {
        viewModel.onTap()
    }
}
