//
//  CardViewModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 11/03/2025.
//

enum CardType {
    case question
    case action
    case idea
}

struct CardViewModel {
    let type: CardType
    let title: String
}
