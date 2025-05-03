//
//  QuestionCollectionViewCell.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import UIKit

struct CategoryViewModel: Hashable {
    let id: Int
    let iconName: String
    let selectedIconName: String?
    let text: String
    let isSelected: Bool
    let isSelectable: Bool
}

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Commissioner-SemiBold", size: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var model: CategoryViewModel?
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.text = nil
        iconImageView.image = nil
    }
    
    func set(model: CategoryViewModel) {
        self.model = model
        
        textLabel.text = model.text
        iconImageView.image = UIImage(named: model.iconName)
        
        setSelected(model.isSelected)
    }
}

private extension CategoryCollectionViewCell {
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
    }
    
    func setSelected(_ isSelected: Bool) {
        guard model?.isSelectable ?? true else { return }
        
        iconImageView.image = isSelected ? UIImage(named: model?.selectedIconName ?? "") : UIImage(named: model?.iconName ?? "")
        textLabel.textColor = isSelected ? UIColor(hex: "#DB5A3D") : .black
    }
}
