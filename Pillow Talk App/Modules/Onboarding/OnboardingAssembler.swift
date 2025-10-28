//
//  OnboardingAssembler.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import UIKit

final class OnboardingAssembler {
    static func configure(completion: (() -> Void)? = nil) -> OnboardingViewController {
        let view = OnboardingViewController()
        let model = OnboardingViewModel()
        let presenter = OnboardingPresenter(view: view, model: model)
        view.presenter = presenter
        return view
    }
}
