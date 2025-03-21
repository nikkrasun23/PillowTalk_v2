//
//  TabBarViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 06/03/2025.
//

import UIKit

final class TabBarViewController: UIViewController {
    private var tabs: [TabView] = []
    private var controllers: [UIViewController] = []
    private var currentViewController: UIViewController?
    private var currentTab: TabViewModel.TabType = .category
    
    private let tabsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        return stackView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerView()
        setupTabs()
        setupControllers()
        selectTab(.category)
    }
}

private extension TabBarViewController {
    func setupContainerView() {
        view.addSubview(tabsStackView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            tabsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabsStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabsStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabsStackView.heightAnchor.constraint(equalToConstant: 108),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: tabsStackView.topAnchor)
        ])
    }
    
    func setupTabs() {
        tabs = [
            .init(viewModel: .init(
                title: "Категорії питань",
                image: UIImage(named: "categoryIconBlue")!,
                selectedImage: UIImage(named: "categoryIconRed")!,
                tabType: .category,
                onTap: { [weak self] in
                    self?.selectTab(.category)
                }
            )),
            .init(viewModel: .init(
                title: "Банка побачень",
                image: UIImage(named: "cupBlue")!,
                selectedImage: UIImage(named: "cupRed")!,
                tabType: .cup,
                onTap: { [weak self] in
                    self?.selectTab(.cup)
                }
            )),
            .init(viewModel: .init(
                title: "Профіль",
                image: UIImage(named: "settingsBlue")!,
                selectedImage: UIImage(named: "settingsRed")!,
                tabType: .profile,
                onTap: { [weak self] in
                    self?.selectTab(.profile)
                }
            ))
        ]
        
        tabs.forEach({ tabsStackView.addArrangedSubview($0) })
    }
    
    func setupControllers() {
        let firstVC = CategoriesAssembler.configure(payload: .init(screenType: .categories))
        let secondVC = CategoriesAssembler.configure(payload: .init(screenType: .cup))
        
        let thirdVC = ProfileTableViewController()
        
        controllers = [firstVC, secondVC, thirdVC]
    }
    
    
    func switchTo(index: Int, animated: Bool = true) {
        let newViewController = controllers[index]
        
        guard currentViewController !== newViewController else { return }
        
        let oldViewController = currentViewController
        currentViewController = newViewController
        
        addChild(newViewController)
        newViewController.view.frame = containerView.bounds
        newViewController.view.alpha = 0
        containerView.addSubview(newViewController.view)
        
        let animationDuration: TimeInterval = animated ? 0.3 : 0.0
        UIView.animate(withDuration: animationDuration, animations: {
            newViewController.view.alpha = 1
            oldViewController?.view.alpha = 0
        }, completion: { _ in
            oldViewController?.view.removeFromSuperview()
            oldViewController?.removeFromParent()
            newViewController.didMove(toParent: self)
        })
    }
    
    func selectTab(_ tab: TabViewModel.TabType) {
        self.currentTab = tab
        
        tabs.forEach { tabView in
            tabView.setSelected(tabView.type == tab)
        }
        
        switchTo(index: tab.rawValue)
    }
}
