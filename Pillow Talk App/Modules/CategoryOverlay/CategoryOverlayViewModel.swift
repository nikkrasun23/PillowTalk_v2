
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
