
import Foundation
import Combine
import UIKit
import FirebaseAnalytics

protocol CategoryOverlayViewModelProtocol {
    var state: Published<CategoryOverlayViewModelState>.Publisher { get }
    
    func viewDidLoad()
}

enum CategoryOverlayViewModelState {
    case idle
    case categories([CategoryModel])
}

final class CategoryOverlayViewModel {
    @Published private var stateInternal: CategoryOverlayViewModelState = .idle
    var state: Published<CategoryOverlayViewModelState>.Publisher {
        $stateInternal
    }
    
    func viewDidLoad() {
        stateInternal = .categories(StorageService.shared.categories)
    }
}

private extension CategoryOverlayViewModel {
    func logCategorySelection() {
//        guard let analyticsParam = StorageService.shared.categories.first(where: { $0.id == currentCategoryId })?.analyticsParam else { return }
//        
//        Analytics.logEvent("select_question_category", parameters: [
//            "category_name": analyticsParam
//        ])
    }
}

