//
//  Card.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import Foundation
struct Card: Equatable {
    let id: Int
    let number: Int
    let color: Color
    let shape: Shape
    let style: Style
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Color: CaseIterable {
    case A, B, C
}

enum Style: CaseIterable {
    case filled, striped, outline
}

enum Shape: CaseIterable {
    case A, B, C
}
