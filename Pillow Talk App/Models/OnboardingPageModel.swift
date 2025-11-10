//
//  OnboardingPageModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 28.10.2025.
//

import Foundation

struct OnboardingPageModel: Hashable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
    let buttonTitle: String
    let isLastPage: Bool
}

// MARK: - Static Data

extension OnboardingPageModel {
    static func getPages() -> [OnboardingPageModel] {
        guard let currentLanguage = Locale.current.language.languageCode?.identifier,
              let dataLanguage = DataLanguage(rawValue: currentLanguage) else { return [] }
        
        let image3 = "onboarding_3_\(dataLanguage.languageCode.lowercased())"
        
        return [
            OnboardingPageModel(
                id: 0,
                title: NSLocalizedString("onboarding_welcome_title", comment: ""),
                description: NSLocalizedString("onboarding_welcome_description", comment: ""),
                imageName: "onboarding_0",
                buttonTitle: NSLocalizedString("onboarding_button_next", comment: ""),
                isLastPage: false
            ),
            OnboardingPageModel(
                id: 1,
                title: NSLocalizedString("onboarding_questions_title", comment: ""),
                description: NSLocalizedString("onboarding_questions_description", comment: ""),
                imageName: "onboarding_1",
                buttonTitle: NSLocalizedString("onboarding_button_next", comment: ""),
                isLastPage: false
            ),
            OnboardingPageModel(
                id: 2,
                title: NSLocalizedString("onboarding_generator_title", comment: ""),
                description: NSLocalizedString("onboarding_generator_description", comment: ""),
                imageName: "onboarding_2",
                buttonTitle: NSLocalizedString("onboarding_button_next", comment: ""),
                isLastPage: false
            ),
            OnboardingPageModel(
                id: 3,
                title: NSLocalizedString("onboarding_start_title", comment: ""),
                description: NSLocalizedString("onboarding_start_description", comment: ""),
                imageName: image3,
                buttonTitle: NSLocalizedString("onboarding_button_start", comment: ""),
                isLastPage: true
            )
        ]
    }
}
