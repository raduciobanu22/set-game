//
//  ViewController.swift
//  SetGame
//
//  Created by Radu on 18/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = Set(setsOfCards: 8)
    
    @IBOutlet var cardsButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Display the cards
        for index in cardsButtons.indices {
            cardsButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
    }
    
    var symbols = ["▲", "●", "◼︎"]

    @IBAction func deal(_ sender: UIButton) {
        print("Deal more cards")
    }
    
}

