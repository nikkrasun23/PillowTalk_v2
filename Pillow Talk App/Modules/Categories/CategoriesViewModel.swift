//
//  CategoriesViewModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import Foundation
import Combine
import UIKit

protocol CategoriesViewModelProtocol {
    var state: Published<CategoriesViewModelState>.Publisher { get }
    
    func viewDidLoad()
    func selectCategory(with id: Int)
    func loadNextPage()
}

enum CategoriesViewModelState {
    case idle(CategoriesPayload.ScreenType)
    case categories([CategoryViewModel])
    case cards([CardViewModel])
}

final class CategoriesViewModel {
    @Published private var stateInternal: CategoriesViewModelState = .idle(.categories)
    var state: Published<CategoriesViewModelState>.Publisher {
        $stateInternal
    }
    
    private let payload: CategoriesPayload
    private var currentCards: [CardViewModel] = []
    private var currentCategoryId: Int = .zero
    
    init(with payload: CategoriesPayload) {
        self.payload = payload
    }
    
    func viewDidLoad() {
        stateInternal = .idle(payload.screenType)
        
        loadNextPage()
    }
    
    func selectCategory(with id: Int) {
        currentCategoryId = id
        currentCards.removeAll()
        
        loadNextPage()
    }
    
    func loadNextPage() {
        switch payload.screenType {
        case .categories:
            setupCategories()
            setupQuestionsAndActions()
        case .cup:
            setupIdeas()
        }
    }
}

private extension CategoriesViewModel {
    func setupCategories() {
        let categories = mapCategories(StorageService.shared.categories)
        stateInternal = .categories(categories)
    }
    
    func setupQuestionsAndActions() {
        guard let category = StorageService.shared.categories.first(where: {$0.id == currentCategoryId}) else {
            print("Fail to find category")
            return
        }
        
        let questions = mapCard(with: .question, texts: category.questions.shuffled())
        let actions = mapCard(with: .action, texts: category.actions.shuffled())
        
        var actionIndex = 0
        for (index, question) in questions.enumerated() {
            if (index > 0 && index % 8 == 0) && actionIndex < actions.count {
                currentCards.append(actions[actionIndex])
                actionIndex += 1
            }
            
            currentCards.append(question)
        }
        
        stateInternal = .cards(currentCards)
    }
    
    func setupIdeas() {
        currentCards.append(contentsOf: mapCard(with: .idea, texts: StorageService.shared.ideas))
        stateInternal = .cards(currentCards)
    }
    
    func mapCategories(_ categories: [CategoryModel]) -> [CategoryViewModel] {
        categories.compactMap { model in
            let iconName = switch model.id {
            case 0: "shapeOneBlack"
            case 1: "shapeSecondBlack"
            case 2: "shapeThirdBlack"
            case 3: "shapeFourthBlack"
            default: "shapeOneBlack"
            }
            
            let selectedIconName = switch model.id {
            case 0: "shapeOneRed"
            case 1: "shapeSecondRed"
            case 2: "shapeThirdRed"
            case 3: "shapeFourthRed"
            default: "shapeOneRed"
            }
            
            return CategoryViewModel(
                id: model.id,
                iconName: iconName,
                selectedIconName: selectedIconName,
                text: model.title,
                isSelected: model.id == currentCategoryId
            )
        }
    }
    
    func mapCard(with type: CardType, texts: [String]) -> [CardViewModel] {
        texts.compactMap { text in
            return .init(
                type: type,
                title: text
            )
        }
    }
}
