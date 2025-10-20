//
//  ProfileTableViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 18.03.2025.
//

import UIKit
import RevenueCatUI
import RevenueCat
import UserNotifications

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let rightTopImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "greenPlant"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let leftBottomImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "orangePlant"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(hex: "#000000").cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(ProfileSwitchTableViewCell.self, forCellReuseIdentifier: ProfileSwitchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hex: "#FFFFFF")
//        tableView.delegate = self
//        tableView.dataSource = self
        return tableView
    }()
    
    enum SettingType {
        case toggle
        case action
    }
    
    private let settings: [(type: SettingType, icon: String, title: String)] = [
        (.action, "share", NSLocalizedString("menuShare", comment: "")/*"Поділитися"*/),
        (.action, "rate", NSLocalizedString("menuRate", comment: "")/*"Оцінити"*/),
        (.action, "bill", NSLocalizedString("menuManageSubscription", comment: "")/*"Керувати підпискою"*/),
        (.action, "language", NSLocalizedString("menuManageLanguage", comment: "")/*"Змінити мову додатку"*/),
        (.toggle, "notification", NSLocalizedString("menuNotifications", comment: "Notifications")/*"Сповіщення"*/)
    ]
    
    private lazy var easterEggService: EasterEggService = {
        let service = EasterEggService {
            UserDefaultsService.isSubscribed = true
        }
        
        return service
    }()
    
    // MARK: - Добавил нажатие на пустое место экрана, чтоб убрать выделение строки
    
    func tapOnTheScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelection))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

    }
    
    @objc private func dismissSelection() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Методы нажатий
    
    private func toggleNotifications(_ isEnabled: Bool) {
        UserDefaultsService.localNotificationsEnabled = isEnabled
        
        guard let currentLanguage = Locale.current.language.languageCode?.identifier,
              let dataLanguage = DataLanguage(rawValue: currentLanguage) else { return }
        
        if isEnabled {
            // Включаем - планируем пуши из кеша
            NotificationService.shared.scheduleNotificationsFromCache(language: dataLanguage)
        } else {
            // Выключаем - удаляем все запланированные локальные пуши
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    private func shareApp() {
        let textToShare = NSLocalizedString("shareDescription", comment: "") + " 💕 https://apps.apple.com/ua/app/pillowtalk/id6740539774"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func rateApp() {
        guard let url = URL(string: "https://apps.apple.com/app/id6740539774?action=write-review") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func manageSubscription() {
        IAPManager.shared.presentPaywall(self)
    }
    
    private func manageLanguage() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileUI()
        tapOnTheScreen()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureEasterEgg()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        let icon = UIImage(named: setting.icon)
        
        switch setting.type {
        case .toggle:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSwitchTableViewCell.identifier, for: indexPath) as? ProfileSwitchTableViewCell else {
                fatalError("Ошибка: ячейка не найдена")
            }
            
            cell.configure(
                icon: icon,
                title: setting.title,
                isOn: UserDefaultsService.localNotificationsEnabled
            ) { [weak self] isOn in
                self?.toggleNotifications(isOn)
            }
            
            return cell
            
        case .action:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
                fatalError("Ошибка: ячейка не найдена")
            }
            
            cell.configure(icon: icon, title: setting.title)
            return cell
        }
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting = settings[indexPath.row]
        
        // Игнорируем тап на ячейку с тогглом
        guard setting.type == .action else { return }
        
        switch setting.icon {
        case "share":
            shareApp()
        case "rate":
            rateApp()
        case "bill":
            manageSubscription()
        case "language":
            manageLanguage()
        default:
            break
        }
    }
    
    private func setupProfileUI() {
        tableView.backgroundColor = UIColor(hex: "#FFFFFF")
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        view.addSubview(rightTopImageView)
        view.addSubview(leftBottomImageView)
        view.addSubview(contentView)
        contentView.addSubview(tableView)

        
        NSLayoutConstraint.activate([
            rightTopImageView.topAnchor.constraint(equalTo: view.topAnchor),
            rightTopImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            rightTopImageView.heightAnchor.constraint(equalToConstant: 184),
            rightTopImageView.widthAnchor.constraint(equalToConstant: 186),
            
            leftBottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftBottomImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            leftBottomImageView.heightAnchor.constraint(equalToConstant: 184),
            leftBottomImageView.widthAnchor.constraint(equalToConstant: 186),
            
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            contentView.heightAnchor.constraint(equalToConstant: 312),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
            
        ])
    }
    
    private func configureEasterEgg() {
        let rightToptapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapRightTopImageView))
        rightTopImageView.addGestureRecognizer(rightToptapGestureRecognizer)
        rightTopImageView.isUserInteractionEnabled = true
        
        let leftBottomtapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didLeftBottomTopImageView))
        leftBottomImageView.addGestureRecognizer(leftBottomtapGestureRecognizer)
        leftBottomImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapRightTopImageView() {
        easterEggService.registerTap(on: .viewA)
    }
    
    @objc private func didLeftBottomTopImageView() {
        easterEggService.registerTap(on: .viewB)
    }
}
