//
//  CategoriesViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import UIKit
import StoreKit
import RevenueCatUI
import RevenueCat
import FirebaseAnalytics

final class CategoriesViewController: UIViewController {
    var presenter: CategoriesPresenterProtocol!
    
    // Track the maximum viewed card index in the current category
    private var maxViewedCardIndexInCurrentCategory: Int = -1
    private var currentCategoryId: Int = -1
    // Track which card indices have already been counted to prevent double counting
    private var viewedCardIndices: Set<Int> = []
    
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

    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = createCategoriesLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var questionsCollectionView: UICollectionView = {
        let layout = createQuestionsLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(QuestionCollectionViewCell.self, forCellWithReuseIdentifier: QuestionCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    private let onboardingTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.textColor = UIColor(hex: "#B3B8C6")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = NSLocalizedString("swipeOnboardingText", comment: "")
        return label
    }()
    
    private typealias CategoriesDataSource = UICollectionViewDiffableDataSource<CategoriesSection, CategoryViewModel>
    private typealias CategoriesSnapshot = NSDiffableDataSourceSnapshot<CategoriesSection, CategoryViewModel>
    private lazy var categoriesDataSource: CategoriesDataSource = configureCategoriesDataSource()
    
    private typealias QuestionsDataSource = UICollectionViewDiffableDataSource<QuestionsSection, CardViewModel>
    private typealias QuestionsSnapshot = NSDiffableDataSourceSnapshot<QuestionsSection, CardViewModel>
    private lazy var questionsDataSource: QuestionsDataSource = configureQuestionsDataSource()

    private enum CategoriesSection {
        case category
    }
    
    private enum QuestionsSection {
        case question
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        showSelectCategoryOverlayIfNeeded()
    }
    
    func showCards(_ cards: [CardViewModel]) {
        // Reset viewed card index when category changes
        if currentCategoryId != presenter.currentCategoryId {
            maxViewedCardIndexInCurrentCategory = -1
            currentCategoryId = presenter.currentCategoryId
            viewedCardIndices.removeAll() // Reset viewed indices for new category
        }
        updateQuestionsDataSource(for: .question, items: cards)
    }
    
    func showCategories(_ categories: [CategoryViewModel]) {
        updateCategoriesDataSource(for: .category, items: categories)
    }
    
    func selectCellAtIndexPath(_ indexPath: IndexPath) {
        categoriesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    func configureScreen(with type: CategoriesPayload.ScreenType) {
        switch type {
        case .categories:
            categoriesCollectionView.isHidden = false
        case .cup:
            categoriesCollectionView.isHidden = true
        }
    }
    
    func requestReviewPopup() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            Analytics.logEvent("popup_review_shown", parameters: nil)
            
            if #available(iOS 18.0, *) {
                AppStore.requestReview(in: windowScene)
            } else {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
    
    func showPayWall() {
        IAPManager.shared.presentPaywall(self)
    }
    
    func resetQuestions() {
        var snapshot = QuestionsSnapshot()
        snapshot.appendSections([.question])
        questionsDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func showOnboarding(_ isShown: Bool) {
        onboardingTitle.isHidden = isShown
    }
    
    func showSelectCategoryOverlayIfNeeded() {
        if UserDefaultsService.selectedCategoryFromOverlay == nil {
            let vc = CategoryOverlayAssembler.configure { [weak self] in
                self?.presenter.selectCategoryFromOverlay()
            }
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
}

private extension CategoriesViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        view.addSubview(rightTopImageView)
        view.addSubview(leftBottomImageView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(questionsCollectionView)
        view.addSubview(onboardingTitle)
        
        NSLayoutConstraint.activate([
            rightTopImageView.topAnchor.constraint(equalTo: view.topAnchor),
            rightTopImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            rightTopImageView.heightAnchor.constraint(equalToConstant: 184),
            rightTopImageView.widthAnchor.constraint(equalToConstant: 186),
            
            leftBottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftBottomImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            leftBottomImageView.heightAnchor.constraint(equalToConstant: 184),
            leftBottomImageView.widthAnchor.constraint(equalToConstant: 186),
            
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -16),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            questionsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionsCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionsCollectionView.heightAnchor.constraint(equalToConstant: 420),
            
            onboardingTitle.topAnchor.constraint(equalTo: questionsCollectionView.bottomAnchor, constant: 12),
            onboardingTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            onboardingTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
        ])
    }

    func createCategoriesLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(150),
            heightDimension: .absolute(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(150),
            heightDimension: .absolute(40)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16, bottom: .zero, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createQuestionsLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(420)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(420)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                let distanceFromCenter = (item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0
                
                let minScale: CGFloat = 0.9
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (abs(distanceFromCenter) / environment.container.contentSize.width) * 0.5, minScale)
                let maxRotation: CGFloat = 0.19
                let rotationCoefficient = min(max(-1, distanceFromCenter / (environment.container.contentSize.width / 2)), 1)
                let rotation = rotationCoefficient * maxRotation
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                let rotationTransform = CGAffineTransform(rotationAngle: rotation)
                item.transform = scaleTransform.concatenating(rotationTransform)
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCategoriesDataSource() -> CategoriesDataSource {
        CategoriesDataSource(collectionView: categoriesCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.set(model: model)
            return cell
        }
    }
    
    private func configureQuestionsDataSource() -> QuestionsDataSource {
        QuestionsDataSource(collectionView: questionsCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: QuestionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? QuestionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.set(model: model)
            return cell
        }
    }
    
    private func updateCategoriesDataSource(for section: CategoriesSection, items: [CategoryViewModel] = []) {
        var snapshot = CategoriesSnapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        categoriesDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateQuestionsDataSource(for section: QuestionsSection, items: [CardViewModel] = []) {
        var snapshot = QuestionsSnapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        questionsDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            guard let item = categoriesDataSource.itemIdentifier(for: indexPath) else { return }
            
            presenter.select(categoryId: item.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == questionsCollectionView {
            // Check if current category is free (id = 0 or id = 5)
            let isFreeCategory = presenter.currentCategoryId == 0 || presenter.currentCategoryId == 5
            
            if !UserDefaultsService.isSubscribed && isFreeCategory {
                // Check daily limit before allowing to view the card
                if UserDefaultsService.hasReachedDailyLimit {
                    DispatchQueue.main.async {
                        self.questionsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                    }
                    showPayWall()
                    return
                }
            }
            
            // Only increment viewed cards count if this is a new card that hasn't been counted yet
            // Skip counting the first card (index 0) - only count from the second card onwards
            if indexPath.item > 0 && indexPath.item > maxViewedCardIndexInCurrentCategory && !viewedCardIndices.contains(indexPath.item) {
                maxViewedCardIndexInCurrentCategory = indexPath.item
                viewedCardIndices.insert(indexPath.item) // Mark this index as viewed
                presenter.incrementShownCardCount()
                
                // Only increment viewed cards count for free categories
                if !UserDefaultsService.isSubscribed && isFreeCategory {
                    UserDefaultsService.incrementViewedCards()
                    
                    // Check if limit reached after incrementing
                    if UserDefaultsService.hasReachedDailyLimit {
                        DispatchQueue.main.async {
                            // Scroll back to previous card if limit reached
                            if indexPath.item > 0 {
                                self.questionsCollectionView.scrollToItem(at: IndexPath(item: indexPath.item - 1, section: 0), at: .centeredHorizontally, animated: true)
                            }
                        }
                        showPayWall()
                        return
                    }
                }
            }
            
            let totalItems = questionsDataSource.snapshot().itemIdentifiers.count
            
            if indexPath.item == totalItems - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    if !self.questionsCollectionView.isDragging && !self.questionsCollectionView.isDecelerating {
                        self.presenter.loadNextPage()
                    }
                }
            }
        }
    }
}
