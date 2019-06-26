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
    
    var shapes: [Card.Shape:CardView.Shape] = [.A: CardView.Shape.diamond, .B: CardView.Shape.oval, .C: CardView.Shape.squiggle]
    var colors: [Card.Color:UIColor] = [.A: UIColor.green, .B: UIColor.red, .C: UIColor.purple]
    var styles: [Card.Style:CardView.Style] = [.A: CardView.Style.filled, .B: CardView.Style.outline, .C: CardView.Style.striped]
    
    @IBOutlet weak var scoreLabel: UILabel!    
    
    @IBOutlet weak var boardView: BoardView! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(recognizer:)))
            swipeGestureRecognizer.direction = .up
            boardView.addGestureRecognizer(swipeGestureRecognizer)
            
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotate(recognizer:)))
            boardView.addGestureRecognizer(rotationGestureRecognizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.dealCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        var cardViews = [CardView]()
        for card in game.cards {
            let cardView = CardView()
            cardView.color = colors[card.color]!
            cardView.style = styles[card.style]!
            cardView.shape = shapes[card.shape]!
            cardView.total = card.total
            
            if game.deck.count == 0 && game.matchedCards.contains(card) {
                cardView.isHidden = true
                continue
            }
            
            if game.selectedCards.contains(card) {
                cardView.isSelected = true
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapCard(recognizer:)))
            cardView.addGestureRecognizer(tapGestureRecognizer)
            cardViews.append(cardView)
        }
        boardView.cardViews = cardViews
        updateDealButton()
        updateScoreLabel()
    }
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBAction func dealButtonTap(_ sender: UIButton) {
        dealMoreCards()
    }
    
    private func selectCard(view: CardView) {
        if let cardIndex = boardView.cardViews.lastIndex(of: view) {
            game.selectCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGameButtonTap(_ sender: UIButton) {
        newGame()
    }
    
    private func newGame() {
        game = Set()
        game.dealCards()
        updateViewFromModel()
    }
    
    private func dealMoreCards() {
        game.dealCards()
        updateViewFromModel()
    }
    
    private func updateDealButton() {
        dealButton.isEnabled = !game.deck.isEmpty
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @objc private func swipe(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .changed: fallthrough
        case .ended: dealMoreCards()
        default: break
        }
    }
    
    @objc private func tapCard(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view as? CardView {
                selectCard(view: cardView)
            }
        default: break
        }
    }
    
    @objc private func rotate(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.cards.shuffle()
            updateViewFromModel()
        default: break
        }
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

