//
//  ViewController.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private var game = SetGame()
    private var cardToViewMap = [Card: SetCardView]() {
        didSet {
            cardToViewMap.filter { !game.board.contains($0.key) }
                .forEach { cardToViewMap.removeValue(forKey: $0.key) }
        }
    }
    
    @IBOutlet private weak var cardContainer: CardContainer! {
        didSet {
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SetViewController.swipeOnCardContainer))
            swipeGestureRecognizer.direction = .down
            cardContainer.addGestureRecognizer(swipeGestureRecognizer)
        }
    }
    
    private func updateViewFromModel() {
        // use array instead of cardToViewMap.values to preserve order and prevent newly delt cards from being added to middle of board
        cardContainer.cards = game.board.map { updateOrCreateCardView(forCard: $0) }
        
        scoreLabel.text = "Score: \(game.score)"
        deal3CardsButton.isUserInteractionEnabled = game.canDealMoreCards
        deal3CardsButton.backgroundColor = game.canDealMoreCards ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBOutlet private weak var deal3CardsButton: UIButton!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBAction private func deal3CardsTouched() {
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction private func newGameTouched() {
        game = SetGame()
        updateViewFromModel()
    }
    
    @objc private func cardTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let view = recognizer.view as? SetCardView, let card = cardToViewMap.key(forValue: view) {
                game.cardChosen(card: card)
                updateViewFromModel()
            }
        default: break
        }
    }
    
    @objc private func swipeOnCardContainer(recognizer: UISwipeGestureRecognizer) {
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
    
    private func updateOrCreateCardView(forCard card: Card) -> SetCardView {
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
                let view = SetCardView(symbol: symbol!, quantity: quantity!, shading: shading!, color: color!)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetViewController.cardTapped(recognizer:)))
                view.addGestureRecognizer(tapGestureRecognizer)
                cardToViewMap[card] = view
                return view
            }
        }
        
        if let view = cardToViewMap[card] {
            view.color = colorMap[card.color]!
            view.shading = shadingMap[card.shading]!
            view.quantity = SetCardView.Quantity(rawValue: card.quantity)!
            view.symbol = symbolsMap[card.symbol]!
            view.isSelected = game.isSelected(card)
            return view
        } else {
            let view = createViewFromModel(forCard: card)!
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

