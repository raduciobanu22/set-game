//
//  Set.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import Foundation

class Set {
    var deck = [Card]()
    var cards = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var score = 0
    
    var isSelectionAMatch: Bool? {
        get {
            if selectedCards.count != 3 {
                return false
            }
            
            // They all have the same color or have three different colors
            for color in Card.Color.allCases {
                if selectedCards.filter({$0.color == color}).count == 2 {
                    return false
                }
            }
            
            for symbolsNumber in 1...3 {
                if selectedCards.filter({$0.total == symbolsNumber}).count == 2 {
                    return false
                }
            }

            // They all have the same shape or have three different shapes.
            for shape in Card.Shape.allCases {
                if selectedCards.filter({$0.shape == shape}).count == 2 {
                    return false
                }
            }
            
            // They all have the same shading or have three different shadings.
            for style in Card.Style.allCases {
                if selectedCards.filter({$0.style == style}).count == 2 {
                    return false
                }
            }
            
            return true
        }
    }
    
    init() {
        var id = 1
        for symbolsNumber in 1...3 {
            for shape in Card.Shape.allCases {
                for style in Card.Style.allCases {
                    for color in Card.Color.allCases {
                        deck.append(
                            Card(
                                id: id,
                                total: symbolsNumber,
                                color: color,
                                shape: shape,
                                style: style)
                        )
                        id += 1
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    func selectCard(at index: Int) {
        // Card has already been matched, nothing to do
        if deck.count == 0 && matchedCards.contains(cards[index]) {
            return
        }
        
        if selectedCards.count < 3 {
            // If the card has already been selected we deselect it
            if let alreadySelectedIndex = selectedCards.firstIndex(of: cards[index]) {
                selectedCards.remove(at: alreadySelectedIndex)
            } else {
                // Otherwise we can select it
                selectedCards.append(cards[index])
            }
        } else {
            // If the selection is a match, remove them from the displayed cards
            // and add them to the matched cards
            if let match = isSelectionAMatch, match == true {
                matchedCards += selectedCards
                // Remove each selected card from the cards array and insert a new card from the deck at the same index
                if deck.count > 0 {
                    for _ in selectedCards.indices {
                        let indexToInsertAt = cards.firstIndex(of: selectedCards.removeFirst())
                        cards.remove(at: indexToInsertAt!)
                        // If we don't have cards in the deck anymore, don't remove from cards, just make sure to check
                        // in the controller if the displayed card is among the matched list and hide it
                        cards.insert(deck.removeFirst(), at: indexToInsertAt!)
                    }
                }
                score += 5
            } else {
                score -= 3
            }
            selectedCards.removeAll()
            selectedCards.append(cards[index])
        }
    }
    
    func dealCards() {
        if !deck.isEmpty {
            let range = (cards.isEmpty) ? 0...11 : 0...2
            cards += deck[range]
            deck.removeFirst(range.count)
        }
    }
    
    func shuffleCards() {
        cards.shuffle()
    }
}
