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
    private var cancellables = Set<AnyCancellable>()
    
    init(view: OnboardingViewController, model: OnboardingViewModel) {
        self.view = view
        self.model = model
        
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
        // Можно добавить аналитику или дополнительную логику при изменении страницы
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
                    view?.finishOnboarding()
                }
            }
            .store(in: &cancellables)
    }
}
