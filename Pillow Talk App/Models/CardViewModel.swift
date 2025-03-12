//
//  CardViewModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 11/03/2025.
//

import Foundation

enum CardType {
    case question
    case action
    case idea
}

struct CardViewModel: Hashable {
    let id: UUID = UUID()
    let type: CardType
    let title: String
}
