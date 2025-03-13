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
        
        switch payload.screenType {
        case .categories:
            setupCategories()
        case .cup:
            setupIdeas()
            
            stateInternal = .cards(currentCards)
        }
    }
    
    func selectCategory(with id: Int) {
        currentCategoryId = id
        currentCards.removeAll()
        
        setupCategories()
    }
}

private extension CategoriesViewModel {
    func setupCategories() {
        let categories = mapCategories(StorageService.shared.categories)
        stateInternal = .categories(categories)
        
        setupQuestionsAndActions()
        
        stateInternal = .cards(currentCards)
    }
    
    func setupQuestionsAndActions() {
        guard let category = StorageService.shared.categories.first(where: {$0.id == currentCategoryId}) else {
            print("Fail to find category")
            return
        }
        
        let questions = mapCard(with: .question, texts: category.questions)
        let actions = mapCard(with: .action, texts: category.actions)
        
        var actionIndex = 0
        for (index, question) in questions.enumerated() {
            if (index > 0 && index % 8 == 0) && actionIndex < actions.count {
                currentCards.append(actions[actionIndex])
                actionIndex += 1
            }
            
            currentCards.append(question)
        }
    }
    
    func setupIdeas() {
        currentCards = mapCard(with: .idea, texts: StorageService.shared.ideas)
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
