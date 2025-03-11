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
    
    private let questionsView: QuestionView = {
        let view = QuestionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, CategoryViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CategoryViewModel>
    private lazy var dataSource: DataSource = configureDataSource()
    
    private var cardInitialCenter: CGPoint = .zero
    private let swipeThreshold: CGFloat = 100.0
    
    private enum SwipeDirection {
       case left, right
    }
    
    private enum Section {
        case category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGestures()
        presenter.viewDidLoad()
    }
    
    func showCard(with model: CardViewModel) {
        UIView.animate(withDuration: 0.1, animations: {
            self.questionsView.alpha = 0
        }, completion: { _ in
            self.questionsView.setup(with: model)

            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                self.questionsView.alpha = 1
                self.questionsView.transform = .identity
            })
        })
    }
    
    func showCategories(_ categories: [CategoryViewModel]) {
        updateDataSource(for: .category, items: categories)
    }
    
    func selectCellAtIndexPath(_ indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    func configureScreen(with type: CategoriesPayload.ScreenType) {
        switch type {
        case .categories:
            collectionView.isHidden = false
        case .cup:
            collectionView.isHidden = true
        }
    }
    
    func shakeCard() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        questionsView.layer.add(animation, forKey: "shake")
    }
}

private extension CategoriesViewController {
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        
        view.addSubview(rightTopImageView)
        view.addSubview(leftBottomImageView)
        view.addSubview(questionsView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            rightTopImageView.topAnchor.constraint(equalTo: view.topAnchor),
            rightTopImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            rightTopImageView.heightAnchor.constraint(equalToConstant: 184),
            rightTopImageView.widthAnchor.constraint(equalToConstant: 186),
            
            leftBottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftBottomImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            leftBottomImageView.heightAnchor.constraint(equalToConstant: 184),
            leftBottomImageView.widthAnchor.constraint(equalToConstant: 186),
            
            questionsView.heightAnchor.constraint(equalToConstant: 420),
            questionsView.widthAnchor.constraint(equalToConstant: 300),
            questionsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func createLayout() -> UICollectionViewLayout {
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
    
    private func configureDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
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
    
    private func updateDataSource(for section: Section, items: [CategoryViewModel] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupGestures() {
        cardInitialCenter = questionsView.center
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        questionsView.addGestureRecognizer(panGesture)
        questionsView.isUserInteractionEnabled = true
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .began:
            cardInitialCenter = questionsView.center
            
        case .changed:
            let xOffset = translation.x * 0.8
            questionsView.center = CGPoint(
                x: cardInitialCenter.x + xOffset,
                y: cardInitialCenter.y
            )
            
            let maxRotation: CGFloat = 0.3
            let progress = min(abs(xOffset) / (view.bounds.width / 2), 1.0)
            let rotationAngle = (xOffset > 0 ? 1 : -1) * progress * maxRotation
            
            questionsView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
        case .ended, .cancelled:
            let shouldComplete = abs(translation.x) > swipeThreshold || abs(velocity.x) > 800
            
            if shouldComplete {
                let direction: SwipeDirection = translation.x > 0 ? .right : .left
                animateCardOut(to: direction)

                if direction == .right {
                    presenter.swipeRight()
                } else {
                    presenter.swipeLeft()
                }
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.5,
                    options: [],
                    animations: {
                        self.questionsView.center = self.cardInitialCenter
                        self.questionsView.transform = .identity
                    },
                    completion: nil
                )
            }
        default:
            break
        }
    }
    
    private func animateCardOut(to direction: SwipeDirection) {
        let targetX = direction == .right ? view.bounds.width + 200 : -view.bounds.width - 200
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.questionsView.center.x = targetX
        
                let rotationAngle = direction == .right ? 0.4 : -0.4
                self.questionsView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            },
            completion: { _ in
                self.questionsView.center = self.cardInitialCenter
                self.questionsView.transform = .identity
            }
        )
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        presenter.select(categoryId: item.id)
    }
}
