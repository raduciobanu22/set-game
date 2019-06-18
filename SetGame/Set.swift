//
//  Set.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import Foundation

class Set {
    var cards = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    
    init(setsOfCards: Int) {
        for index in 1...setsOfCards {
            let card = Card(id: index)
            cards += [card, card, card]
        }
        cards.shuffle()
    }    
}
