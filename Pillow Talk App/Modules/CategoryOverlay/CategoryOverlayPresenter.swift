//
//  CategoryOverlayPresenter.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 23/06/2025.
//

import Foundation
import Combine
import UIKit
import FirebaseAnalytics

protocol CategoryOverlayPresenterProtocol {
    func viewDidLoad()
    func select(categoryId: Int)
}

final class CategoryOverlayPresenter: CategoryOverlayPresenterProtocol {
    private weak var view: CategoryOverlayViewController?
    private let model: CategoryOverlayViewModel
    private var cancellables = Set<AnyCancellable>()
    private var selectedCategoryCompletion: (() -> Void)?
    private var categories: [CategoryOverlayItemModel] = []

    init(view: CategoryOverlayViewController, model: CategoryOverlayViewModel, selectedCategoryCompletion: (() -> Void)? = nil) {
        self.model = model
        self.view = view
        self.selectedCategoryCompletion = selectedCategoryCompletion
        
        subscribe()
    }
    
    func viewDidLoad() {
        model.viewDidLoad()
    }
    
    func select(categoryId: Int) {
        UserDefaultsService.selectedCategoryFromOverlay = categoryId
        
        selectedCategoryCompletion?()
        
        guard let analyticsParam = categories.first(where: {$0.categoryId == categoryId})?.analyticsParam else { return }
        
        Analytics.logEvent("select_question_category", parameters: [
            "category": analyticsParam
        ])
    }

    deinit {
        cancellables.removeAll()
    }
}

private extension CategoryOverlayPresenter {
    func subscribe() {
        model.state
            .receive(on: RunLoop.main)
            .sink {[weak self] value in
                guard let self else { return }
                
                switch value {
                case .categories(let categories):
                    let models = categories.compactMap { category in
                        return CategoryOverlayItemModel(
                            categoryId: category.id,
                            text: category.overlayTitle,
                            analyticsParam: category.analyticsParam
                        )
                    }
                    
                    view?.setContent(models)
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
