//
//  ViewController.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    var game = SetGame()
    var cardToViewMap = [Card: SetCardView]()
    
    @IBOutlet weak var cardContainer: CardContainer! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SetViewController.swipeOnCardContainer))
            swipeGestureRecognizer.direction = .down
            cardContainer.addGestureRecognizer(swipeGestureRecognizer)
        }
    }
    @IBOutlet weak var deal3CardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        if let frame = deal3CardsButton.superview?.convert(deal3CardsButton.frame, to: self.cardContainer) {
            SetCardView.deckPosition = frame
        }
    }
    
    @IBAction func deal3CardsTouched() {
        
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction func newGameTouched() {
        game = SetGame()
        updateViewFromModel()
    }
    
    let symbolsMap: [Int: SetCardView.Symbol] = [
        1: .diamond,
        2: .oval,
        3: .squiggle
    ]
    
    let shadingMap: [Int: SetCardView.Shading] = [
        1: .open,
        2: .striped,
        3: .fill
    ]
    
    let colorMap: [Int: SetCardView.Color] = [
        1: .red,
        2: .purple,
        3: .green
    ]
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        // use array instead of cardToViewMap.values to preserve order and prevent newly delt cards from being added to middle of board
        var views = [SetCardView]()
        for card in game.board {
            if let view = cardToViewMap[card] {
                view.color = colorMap[card.color]!
                view.shading = shadingMap[card.shading]!
                view.quantity = SetCardView.Quantity(rawValue: card.quantity)!
                view.symbol = symbolsMap[card.symbol]!
                views.append(view)
            } else {
                let view = SetCardView(symbol: symbolsMap[card.symbol]!, quantity: SetCardView.Quantity(rawValue: card.quantity)!, shading: shadingMap[card.shading]!, color: colorMap[card.color]!)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.cardTapped(recognizer:)))
                view.addGestureRecognizer(tapGestureRecognizer)
                view.isFaceUp = false
                cardToViewMap[card] = view
                views.append(view)
            }
        }
        cardToViewMap.values.forEach { $0.isSelected = false }
        cardToViewMap.filter { !game.board.contains($0.key) }
            .forEach { cardToViewMap.removeValue(forKey: $0.key) }
        game.selectedCards.forEach { cardToViewMap[$0]?.isSelected = true }
        cardContainer.cards = views
        deal3CardsButton.isUserInteractionEnabled = game.canDealMoreCards
        deal3CardsButton.backgroundColor = game.canDealMoreCards ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    @objc func cardTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let view = recognizer.view as? SetCardView, let card = cardToViewMap.key(forValue: view) {
//                UIView.transition(with: view, duration: 0.6, options: [.transitionFlipFromLeft, .curveEaseInOut], animations: {
//                    view.isFaceUp = !view.isFaceUp
//                }, completion: nil)
                game.cardChosen(card: card)
                updateViewFromModel()
            }
        default: break
        }
    }
    
    @objc func swipeOnCardContainer(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            deal3CardsTouched()
        default: break
        }
    }
    
}


// written by Cristik on SO
extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}

