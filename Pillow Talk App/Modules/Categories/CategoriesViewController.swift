//
//  CategoriesViewController.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import UIKit

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
        return collectionView
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
}

private extension CategoriesViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        view.addSubview(rightTopImageView)
        view.addSubview(leftBottomImageView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(questionsCollectionView)
        
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
            
            questionsCollectionView.bottomAnchor.constraint(equalTo: categoriesCollectionView.topAnchor,constant: -120),
            questionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionsCollectionView.heightAnchor.constraint(equalToConstant: 420)
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
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.9
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width) * 0.5, minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
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
        guard let item = categoriesDataSource.itemIdentifier(for: indexPath) else { return }
        
        presenter.select(categoryId: item.id)
    }
}
