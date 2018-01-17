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
    var cardToViewMap = [Card: SetCardView]() {
        didSet {
            cardToViewMap.filter { !game.board.contains($0.key) }
                .forEach { cardToViewMap.removeValue(forKey: $0.key) }
        }
    }
    
    @IBOutlet weak var cardContainer: CardContainer! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SetViewController.swipeOnCardContainer))
            swipeGestureRecognizer.direction = .down
            cardContainer.addGestureRecognizer(swipeGestureRecognizer)
        }
    }
    
    func updateViewFromModel() {
        // use array instead of cardToViewMap.values to preserve order and prevent newly delt cards from being added to middle of board
        let views = game.board.map { updateOrCreateCardView(forCard: $0) }
        cardToViewMap.forEach { $0.value.isSelected = game.selectedCards.contains($0.key) }
        cardContainer.cards = views
        
        scoreLabel.text = "Score: \(game.score)"
        deal3CardsButton.isUserInteractionEnabled = game.canDealMoreCards
        deal3CardsButton.backgroundColor = game.canDealMoreCards ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBOutlet weak var deal3CardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func deal3CardsTouched() {
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction func newGameTouched() {
        game = SetGame()
        updateViewFromModel()
    }
    
    @objc func cardTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let view = recognizer.view as? SetCardView, let card = cardToViewMap.key(forValue: view) {
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
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        if let frame = deal3CardsButton.superview?.convert(deal3CardsButton.frame, to: self.cardContainer) {
            SetCardView.deckPosition = frame
        }
    }
    
    func updateOrCreateCardView(forCard card: Card) -> SetCardView {
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
        
        func createViewFromModel(forCard card: Card) -> SetCardView? {
            let symbol = symbolsMap[card.symbol]
            let quantity = SetCardView.Quantity(rawValue: card.quantity)
            let shading = shadingMap[card.shading]
            let color = colorMap[card.color]
            if symbol == nil || quantity == nil || shading == nil || color == nil {
                return nil
            } else {
                return SetCardView(symbol: symbol!, quantity: quantity!, shading: shading!, color: color!)
            }
        }
        
        if let view = cardToViewMap[card] {
            view.color = colorMap[card.color]!
            view.shading = shadingMap[card.shading]!
            view.quantity = SetCardView.Quantity(rawValue: card.quantity)!
            view.symbol = symbolsMap[card.symbol]!
            return view
        } else {
            let view = createViewFromModel(forCard: card)!
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.cardTapped(recognizer:)))
            view.addGestureRecognizer(tapGestureRecognizer)
            cardToViewMap[card] = view
            return view
        }
    }
}

// written by Cristik on SO
extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}

