//
//  CategoryOverlayAssembler.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 23/06/2025.
//

final class CategoryOverlayAssembler {
    static func configure(_ selectedCategoryCompletion: (() -> Void)? = nil) -> CategoryOverlayViewController {
        let view = CategoryOverlayViewController()
        let model = CategoryOverlayViewModel()
        let presenter = CategoryOverlayPresenter(
            view: view,
            model: model,
            selectedCategoryCompletion: selectedCategoryCompletion
        )
        
        view.presenter = presenter
        return view
    }
}
