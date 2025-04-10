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
        label.text = "Хочеш ще одне питання? \nПросто змахни картку!"
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
    
    func showCards(_ cards: [CardViewModel]) {
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
            
            onboardingTitle.topAnchor.constraint(equalTo: questionsCollectionView.bottomAnchor, constant: 22),
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
            
            if !UserDefaultsService.isSubscribed {
                if UserDefaultsService.hasReachedDailyLimit {
                    DispatchQueue.main.async {
                        self.questionsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                    }
                    showPayWall()
                    return
                }

                if indexPath.item >= 5 {
                    DispatchQueue.main.async {
                        self.questionsCollectionView.scrollToItem(at: IndexPath(item: 4, section: 0), at: .centeredHorizontally, animated: true)
                    }
                    showPayWall()
                    return
                }

                UserDefaultsService.incrementViewedCards()
            }
            
            if indexPath.item > presenter.shownCardsCount {
                presenter.incrementShownCardCount()
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
