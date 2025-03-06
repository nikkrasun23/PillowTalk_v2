//
//  SettingsView.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 01.03.2025.
//

import Foundation
import UIKit

class SettingsView: UIView {
    
    // MARK: BG
    
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Notifications
    
    let notificationsIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .bell
        return image
    }()
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Сповіщення"
        return label
    }()
    
    // MARK: - Share
    
    let shareIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .share
        return image
    }()
    
    let shareLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Поділитися"
        return label
    }()
    
    // MARK: - Rate
    
    let rateIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .rate
        return image
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Оцінити"
        return label
    }()
    
    // MARK: - Language
    
    let languageIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .earth
        return image
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Мови"
        return label
    }()
    
    // MARK: - Subscription
    
    let subscriptionIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .bill
        return image
    }()
    
    let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Керувати підпискою"
        return label
    }()
    
    // MARK: - Privacy policy
    
    let policyIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .policy
        return image
    }()
    
    let policyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#33363F")
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Політика конфіденційності"
        return label
    }()
    
    // MARK: - Setup UI
    
//    override init(frame: CGRect) {
//
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        
//        super.init(coder: coder)
//        setupUI()
//    }
//    
//    private func setupUI() {
//        addSubview(bgView)
//        bgView.addSubview(notificationsIcon)
//        bgView.addSubview(notificationsLabel)
//        bgView.addSubview(shareIcon)
//        bgView.addSubview(shareLabel)
//        bgView.addSubview(rateIcon)
//        bgView.addSubview(rateLabel)
//        bgView.addSubview(languageIcon)
//        bgView.addSubview(languageLabel)
//        bgView.addSubview(subscriptionIcon)
//        bgView.addSubview(subscriptionLabel)
//        bgView.addSubview(policyIcon)
//        bgView.addSubview(policyLabel)
//        
//        NSLayoutConstraint.activate([
//            bgView.widthAnchor.constraint(equalToConstant: 345),
//            bgView.heightAnchor.constraint(equalToConstant: 392),
//            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 153),
//            bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
//            
//            notificationsIcon.widthAnchor.constraint(equalToConstant: 24),
//            notificationsIcon.heightAnchor.constraint(equalToConstant: 24),
//            notificationsIcon.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 16),
//            notificationsIcon.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 24),
//            
//            notificationsLabel.heightAnchor.constraint(equalToConstant: 20),
//            notificationsLabel.leftAnchor.constraint(equalTo: notificationsIcon.rightAnchor, constant: -16),
//            notificationsLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 26),
//            
//            shareIcon.widthAnchor.constraint(equalToConstant: 24),
//            shareIcon.heightAnchor.constraint(equalToConstant: 24),
//            shareIcon.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 16),
//            shareIcon.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 88),
//            
//            shareLabel.heightAnchor.constraint(equalToConstant: 20),
//            shareLabel.leftAnchor.constraint(equalTo: shareIcon.rightAnchor, constant: -16),
//            shareLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 90),
//    
//            
//            
//            
//        ])
    }
    

