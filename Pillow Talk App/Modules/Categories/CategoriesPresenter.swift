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
    func viewDidLoad()
    func select(categoryId: Int)
    func swipeLeft()
    func swipeRight()
}

final class CategoriesPresenter: CategoriesPresenterProtocol {
    private weak var view: CategoriesViewController?
    private let model: CategoriesViewModel
    private var cancellables = Set<AnyCancellable>()

    init(view: CategoriesViewController, model: CategoriesViewModel) {
        self.model = model
        self.view = view
        
        subscribe()
    }
    
    func viewDidLoad() {
        model.viewDidLoad()
    }
    
    func select(categoryId: Int) {
        model.selectCategory(with: categoryId)
    }
    
    func swipeLeft() {
        model.previousCard()
    }
    
    func swipeRight() {
        model.nextCard()
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
                case .card(let card):
                    view?.showCard(with: card)
                case .categories(let categories):
                    view?.showCategories(categories)
                case .idle(let screenType):
                    view?.configureScreen(with: screenType)
                case .shake:
                    view?.shakeCard()
                }
            }
            .store(in: &cancellables)
    }
}
