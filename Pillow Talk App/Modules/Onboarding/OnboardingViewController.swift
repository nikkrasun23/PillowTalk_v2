//
//  OnboardingViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var presenter: OnboardingPresenterProtocol!
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
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
        label.font = UIFont(name: "Commissioner-SemiBold", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<OnboardingSection, OnboardingPageModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<OnboardingSection, OnboardingPageModel>
    private lazy var dataSource: DataSource = configureDataSource()
    
    private var pages: [OnboardingPageModel] = []
    
    private enum OnboardingSection {
        case main
    }
    
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
        updateDataSource(pages)
        updateButtonTitle(for: 0)
    }
    
    func scrollToPage(_ index: Int, animated: Bool) {
        guard index < pages.count else { return }
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        pageControl.currentPage = index
        updateButtonTitle(for: index)
    }
    
    func finishOnboarding() {
        // Закрываем онбординг или переходим к основному экрану
        dismiss(animated: true)
    }
}

// MARK: - Private Methods

private extension OnboardingViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        nextButton.addSubview(nextButtonLabel)
        
        setupConstraints()
        setupActions()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Collection View
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            // Page Control
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            
            // Next Button
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
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
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, page in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? OnboardingCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: page)
            return cell
        }
    }
    
    func updateButtonTitle(for pageIndex: Int) {
        guard pageIndex < pages.count else { return }
        nextButtonLabel.text = pages[pageIndex].buttonTitle
    }
    
    func updateDataSource(_ pages: [OnboardingPageModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(pages, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if currentPage != pageControl.currentPage {
            pageControl.currentPage = currentPage
            updateButtonTitle(for: currentPage)
            presenter.pageChanged(to: currentPage)
        }
    }
}

