//
//  OnboardingViewModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import Foundation
import Combine

protocol OnboardingViewModelProtocol {
    var state: Published<OnboardingViewModelState>.Publisher { get }
    
    func viewDidLoad()
    func nextPage()
    func skipOnboarding()
}

enum OnboardingViewModelState {
    case idle
    case pages([OnboardingPageModel])
    case currentPage(Int)
    case finished
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    @Published private var stateInternal: OnboardingViewModelState = .idle
    
    var state: Published<OnboardingViewModelState>.Publisher {
        $stateInternal
    }
    
    private var pages: [OnboardingPageModel] = []
    private var currentPageIndex: Int = 0
    
    func viewDidLoad() {
        pages = OnboardingPageModel.getPages()
        stateInternal = .pages(pages)
        stateInternal = .currentPage(currentPageIndex)
    }
    
    func nextPage() {
        let nextIndex = currentPageIndex + 1
        
        if nextIndex < pages.count {
            currentPageIndex = nextIndex
            stateInternal = .currentPage(currentPageIndex)
        } else {
            finishOnboarding()
        }
    }
    
    func skipOnboarding() {
        finishOnboarding()
    }
}

private extension OnboardingViewModel {
    func finishOnboarding() {
        UserDefaultsService.isOnboardingCompleted = true
        stateInternal = .finished
    }
}
