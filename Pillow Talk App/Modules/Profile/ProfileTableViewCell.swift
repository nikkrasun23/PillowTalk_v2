//
//  ProfileTableViewCell.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 18.03.2025.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // не знаю нужно ли это свойство в данном случае
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.textColor = UIColor(hex: "#33363F")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                
        iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        iconImageView.widthAnchor.constraint(equalToConstant: 24),
        iconImageView.heightAnchor.constraint(equalToConstant: 24),
                
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      ])
    }
    
    func configure(icon: UIImage?, title: String) {
        iconImageView.image = icon
        titleLabel.text = title
    }
}
