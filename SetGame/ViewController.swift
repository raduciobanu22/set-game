//
//  ViewController.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = Set()
    
    var shapes: [Shape:String] = [.A: "▲", .B: "●", .C: "◼︎"]
    
    var colors: [Color: UIColor] = [.A: UIColor.blue, .B: UIColor.cyan, .C: UIColor.orange]
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardsButtons: [UIButton]! {
        didSet {
            for index in cardsButtons.indices {
                let card = cardsButtons[index]
                card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                card.layer.cornerRadius = 8.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        game.dealCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardsButtons.indices {
            // These cards are visible
            if index < game.cards.count {
                let card = game.cards[index]
                
                if game.deck.count == 0 && game.matchedCards.contains(card) {
                    hideCard(cardButton: cardsButtons[index])
                    continue
                }
                
                // If card is selected, add border
                if game.selectedCards.contains(card) {
                    cardsButtons[index].layer.borderWidth = 3.0
                    cardsButtons[index].layer.borderColor = UIColor.red.cgColor
                } else {
                    cardsButtons[index].layer.borderWidth = 1.0
                    cardsButtons[index].layer.borderColor = UIColor.purple.cgColor
                }
                
                // If we have a set, use a different color border
                drawShape(on: cardsButtons[index])
            // These aren't visible
            } else {
                hideCard(cardButton: cardsButtons[index])
            }
        }
        updateDealButton()
        updateScoreLabel()
    }
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBAction func deal(_ sender: UIButton) {
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardsButtons.lastIndex(of: sender) {
            game.selectCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        game.dealCards()
        updateViewFromModel()
    }
    
    /// Draws the correct shape on the given button
    ///
    /// - Parameter button: Card button
    private func drawShape(on button: UIButton) {
        if let cardIndex = cardsButtons.lastIndex(of: button) {
            let card = game.cards[cardIndex]
            var attributes: [NSAttributedString.Key:Any] = [
                .strokeWidth : (card.style == .filled || card.style == .striped) ? 0 : 5.0,
                .strokeColor : colors[card.color]!
            ]
            
            if card.style == .striped {
                attributes[.foregroundColor] = colors[card.color]!.withAlphaComponent(0.15)
            } else if card.style == .filled {
                attributes[.foregroundColor] = colors[card.color]!.withAlphaComponent(1.0)
            }
            
            let symbol = shapes[card.shape]!.repeated(n: card.number)
            let title = NSAttributedString(string: symbol, attributes: attributes)
            button.setAttributedTitle(title, for: UIControl.State.normal)
        }
    }
    
    private func updateDealButton() {
        if game.deck.isEmpty {
            dealButton.isEnabled = false
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func hideCard(cardButton: UIButton) {
        cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        cardButton.layer.borderWidth = 0
        cardButton.setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
        cardButton.setTitle("", for: UIControl.State.normal)
    }

}

extension String {
    func repeated(n times: Int) -> String {
        var newString = self
        for _ in 1..<times {
            newString += self
        }
        return newString
    }
}

