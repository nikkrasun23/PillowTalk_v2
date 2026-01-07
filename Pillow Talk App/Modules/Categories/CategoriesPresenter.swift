//
//  CategoriesPresenter.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import Foundation
import Combine
import UIKit

protocol CategoriesPresenterProtocol {
    var shownCardsCount: Int { get }
    var currentCategoryId: Int { get }
    
    func viewDidLoad()
    func select(categoryId: Int)
    func loadNextPage()
    func incrementShownCardCount()
    func selectCategoryFromOverlay()
}

final class CategoriesPresenter: CategoriesPresenterProtocol {
    private weak var view: CategoriesViewController?
    private let model: CategoriesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var shownCardsCount: Int {
        return UserDefaultsService.shownCardsCount
    }
    
    var currentCategoryId: Int {
        return model.currentCategoryId
    }

    init(view: CategoriesViewController, model: CategoriesViewModel) {
        self.model = model
        self.view = view
        
        subscribe()
    }
    
    func viewDidLoad() {
        model.viewDidLoad()
    }
    
    func select(categoryId: Int) {
        if categoryId == UserDefaultsService.selectedCategoryFromOverlay ?? .zero || UserDefaultsService.isSubscribed || categoryId == 5 {
            model.selectCategory(with: categoryId)
        } else {
            view?.showPayWall()
        }
    }
    
    func loadNextPage() {
        model.loadNextPage()
    }
    
    func incrementShownCardCount() {
        UserDefaultsService.shownCardsCount += 1
        
        if UserDefaultsService.shownCardsCount > 3 && !UserDefaultsService.isRated {
            view?.requestReviewPopup()
            UserDefaultsService.isRated = true
        }
        
        view?.showOnboarding(UserDefaultsService.isOnboardingShown)
        UserDefaultsService.isOnboardingShown = true
    }
    
    func selectCategoryFromOverlay() {
        guard let categoryId = UserDefaultsService.selectedCategoryFromOverlay else { return }
        
        model.selectCategory(with: categoryId)
        UserDefaultsService.viewedCardsCount = 0
    }

    deinit {
        cancellables.removeAll()
    }
}

private extension CategoriesPresenter {
    func subscribe() {
        model.state
            .receive(on: RunLoop.main)
            .sink {[weak self] value in
                guard let self else { return }
                
                switch value {
                case .cards(let cards):
                    view?.showCards(cards)
                case .categories(let categories):
                    view?.showCategories(categories)
                case .idle(let screenType):
                    view?.configureScreen(with: screenType)
                }
            }
            .store(in: &cancellables)
    }
}
