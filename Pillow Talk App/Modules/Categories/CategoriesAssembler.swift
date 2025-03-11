//
//  CategoriesAssembler.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

struct CategoriesPayload {
    enum ScreenType {
        case categories
        case cup
    }
    
    let screenType: ScreenType
}

final class CategoriesAssembler {
    static func configure(payload: CategoriesPayload) -> CategoriesViewController {
        let view = CategoriesViewController()
        let model = CategoriesViewModel(with: payload)
        let presenter = CategoriesPresenter(
            view: view,
            model: model
        )
        
        view.presenter = presenter
        return view
    }
}
