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
    func updateCurrentPage(to index: Int)
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
        
        // Небольшая задержка для корректной обработки состояний
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.stateInternal = .currentPage(self.currentPageIndex)
        }
    }
    
    func nextPage() {
        let nextIndex = currentPageIndex + 1
        print("OnboardingViewModel: nextPage - current: \(currentPageIndex), next: \(nextIndex), total: \(pages.count)")
        
        if nextIndex < pages.count {
            currentPageIndex = nextIndex
            print("OnboardingViewModel: Moving to page \(currentPageIndex)")
            stateInternal = .currentPage(currentPageIndex)
        } else {
            print("OnboardingViewModel: Reached end, finishing onboarding")
            finishOnboarding()
        }
    }
    
    func skipOnboarding() {
        finishOnboarding()
    }
    
    func updateCurrentPage(to index: Int) {
        guard index >= 0 && index < pages.count else { return }
        currentPageIndex = index
    }
}

private extension OnboardingViewModel {
    func finishOnboarding() {
        print("OnboardingViewModel: finishOnboarding called")
        UserDefaultsService.isOnboardingCompleted = true
        print("OnboardingViewModel: Setting state to .finished")
        stateInternal = .finished
    }
}
