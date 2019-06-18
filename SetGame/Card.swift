//
//  Card.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import Foundation
struct Card: Hashable {
    private var id: Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
