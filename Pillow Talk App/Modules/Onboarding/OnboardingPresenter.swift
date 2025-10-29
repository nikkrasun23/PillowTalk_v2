//
//  OnboardingPresenter.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import Foundation
import Combine

protocol OnboardingPresenterProtocol {
    func viewDidLoad()
    func nextButtonTapped()
    func skipButtonTapped()
    func pageChanged(to index: Int)
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    private weak var view: OnboardingViewController?
    private let model: OnboardingViewModel
    private let completion: (()->Void)?
    private var cancellables = Set<AnyCancellable>()
    
    init(view: OnboardingViewController, model: OnboardingViewModel, completion: (()->Void)?) {
        self.view = view
        self.model = model
        self.completion = completion
        
        subscribe()
    }
    
    func viewDidLoad() {
        model.viewDidLoad()
    }
    
    func nextButtonTapped() {
        model.nextPage()
    }
    
    func skipButtonTapped() {
        model.skipOnboarding()
    }
    
    func pageChanged(to index: Int) {
        // Синхронизируем индекс в модели при ручном скролле
        model.updateCurrentPage(to: index)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Private

private extension OnboardingPresenter {
    func subscribe() {
        model.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle:
                    break
                case .pages(let pages):
                    view?.showPages(pages)
                case .currentPage(let index):
                    view?.scrollToPage(index, animated: true)
                case .finished:
                    print("OnboardingPresenter: Onboarding finished")
                    view?.finishOnboarding()
                    print("OnboardingPresenter: Calling completion")
                    completion?()
                }
            }
            .store(in: &cancellables)
    }
}
