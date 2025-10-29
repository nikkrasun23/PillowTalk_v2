//
//  OnboardingViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var presenter: OnboardingPresenterProtocol!
    
    private var pageViewController: UIPageViewController!
    private var pages: [OnboardingPageModel] = []
    private var pageControllers: [OnboardingPageViewController] = []
    
    // MARK: - UI Elements
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#D45843")
        pageControl.pageIndicatorTintColor = UIColor(hex: "#E5E5E5")
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let nextButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#D45843")
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let nextButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "RussoOne-Regular", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
    func showPages(_ pages: [OnboardingPageModel]) {
        self.pages = pages
        pageControl.numberOfPages = pages.count
        
        // Создаем контроллеры для каждой страницы
        pageControllers = pages.map { OnboardingPageViewController(pageModel: $0) }
        
        // Показываем первую страницу
        if let firstPage = pageControllers.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false)
        }
        
        updateButtonTitle(for: 0)
    }
    
    func scrollToPage(_ index: Int, animated: Bool) {
        guard index < pageControllers.count else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentPageIndex ? .forward : .reverse
        pageViewController.setViewControllers([pageControllers[index]], direction: direction, animated: animated)
        
        pageControl.currentPage = index
        updateButtonTitle(for: index)
    }
    
    func finishOnboarding() {
        print("OnboardingViewController: finishOnboarding called")
        dismiss(animated: true)
    }
  
    // MARK: - Private Properties
    
    private var currentPageIndex: Int {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let index = pageControllers.firstIndex(of: currentViewController as! OnboardingPageViewController) else {
            return 0
        }
        return index
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        // Создаем UIPageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        nextButton.addSubview(nextButtonLabel)
        
        setupConstraints()
        setupActions()
    }
    
    func setupConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Page View Controller
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            // Page Control
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            
            // Next Button
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Next Button Label
            nextButtonLabel.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            nextButtonLabel.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor)
        ])
    }
    
    func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        nextButton.addGestureRecognizer(tapGesture)
        nextButton.isUserInteractionEnabled = true
    }
    
    @objc func nextButtonTapped() {
        presenter.nextButtonTapped()
    }
    
    func updateButtonTitle(for pageIndex: Int) {
        guard pageIndex < pages.count else { return }
        nextButtonLabel.text = pages[pageIndex].buttonTitle
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController,
              let index = pageControllers.firstIndex(of: pageVC) else {
            return nil
        }
        
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        
        return pageControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? OnboardingPageViewController,
              let index = pageControllers.firstIndex(of: pageVC) else {
            return nil
        }
        
        let nextIndex = index + 1
        guard nextIndex < pageControllers.count else { return nil }
        
        return pageControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        let currentIndex = self.currentPageIndex
        pageControl.currentPage = currentIndex
        updateButtonTitle(for: currentIndex)
        
        // Синхронизируем с моделью при ручном листании
        presenter.pageChanged(to: currentIndex)
    }
}

