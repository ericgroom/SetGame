//
//  ViewController.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Set()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var deal3CardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    @IBAction func cardTouched(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            game.cardChosen(index: index)
            updateViewFromModel()
        }
        
    }
    
    @IBAction func deal3CardsTouched() {
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction func newGameTouched() {
        game = Set()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        if let match = game.currentSelectionIsMatch {
            statusLabel.text = match ? "Match!" : "Not a Match!"
        } else {
            statusLabel.text = ""
        }
        cardButtons.forEach {
            $0.hide()
        }
        for index in game.board.indices {
            let text = getAttributedString(forCard: game.board[index])
            cardButtons[index].setAttributedTitle(text, for: UIControlState.normal)
            if game.selectedCards.contains(game.board[index]) {
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else if game.matchedCards.contains(game.board[index]) {
                cardButtons[index].hide()
            } else {
                cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        deal3CardsButton.isUserInteractionEnabled = game.canDealMoreCards
        deal3CardsButton.backgroundColor = game.canDealMoreCards ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    let symbols = ["▲", "●", "■"]
    let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    func getAttributedString (forCard card: Card) -> NSAttributedString {
        let symbol = symbols[card.symbol-1]
        let string = String(repeating: symbol, count: card.quantity)
        let color = colors[card.color-1]
        let shading = Shading(rawValue: card.shading)!
        var attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: -3,
            .strokeColor: color,
            .foregroundColor: color
        ]
        switch shading {
        case .fill:
            break
        case .open:
            attributes[.foregroundColor] = color.withAlphaComponent(0)
        case .striped:
            attributes[.foregroundColor] = color.withAlphaComponent(0.25)
        }
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
//    var circle = Symbol.circle
    
}

// ▲ ● ■

enum Shading: Int {
    case fill = 1, striped, open
}

extension UIButton {
    func hide() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.setTitle(nil, for: UIControlState.normal)
        self.setAttributedTitle(nil, for: UIControlState.normal)
    }
}

