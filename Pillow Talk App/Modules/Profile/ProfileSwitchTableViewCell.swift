//
//  ProfileSwitchTableViewCell.swift
//  Pillow Talk App
//
//  Created by Assistant on 13/10/2025.
//

import UIKit

class ProfileSwitchTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileSwitchCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    private let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(hex: "#F44336")
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    var onSwitchToggled: ((Bool) -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchControl)
        contentView.backgroundColor = UIColor(hex: "#FFFFFF")
        selectionStyle = .none
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
            titleLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func switchValueChanged() {
        onSwitchToggled?(switchControl.isOn)
    }
    
    func configure(icon: UIImage?, title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) {
        iconImageView.image = icon
        titleLabel.text = title
        switchControl.isOn = isOn
        onSwitchToggled = onToggle
    }
}


