//
//  Set.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import Foundation

class SetGame {
    private var deck = [Card]()
    private(set) var board = [Card]()
    var canDealMoreCards: Bool {
        return deck.count > 0
    }
    
    private var selectedCards = [Card]()
    
    private(set) var score = 0
    
    func isSelected(_ card: Card) -> Bool {
        return selectedCards.contains(card)
    }
    
    private func createDeck() -> [Card] {
        var newDeck = [Card]()
        let noOfOptions = 1...3
        for quantity in noOfOptions {
            for symbol in noOfOptions {
                for color in noOfOptions {
                    for shading in noOfOptions {
                        newDeck.append(Card(symbol: symbol, color: color, shading: shading, quantity: quantity))
                    }
                }
            }
        }
        return newDeck
    }
    
    private var scoreForMatch: Int {
        if board.count <= 12 {
            return 10
        } else if board.count <= 15 {
            return 5
        } else {
            return 3
        }
    }
    
    private var penaltyForDeselect: Int {
        return score > 0 ? 1 : 0
    }
    
    private let penaltyForMismatch = 5
    
    func dealCards(numberOfCards: Int = 3) {
        if deck.count >= numberOfCards {
            let range = 0..<numberOfCards
            board.append(contentsOf: deck[range])
            deck.removeSubrange(range)
        }
    }
    
    private func updateSelectedCards(withCard card: Card) {
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
            score -= penaltyForDeselect
        } else {
            selectedCards.append(card)
        }
    }
    
    private func handlePotentialMatch(withCard card: Card) {
        if selectedCards.count == 3, Card.doesMakeSet(selectedCards) {
            score += scoreForMatch
            board.remove(objectsIn: selectedCards)
            selectedCards.removeAll()
            if board.count < 12 {
                dealCards()
            }
        } else {
            selectedCards.removeAll()
            score -= penaltyForMismatch
        }
    }
    
    func cardChosen(card: Card) {
        updateSelectedCards(withCard: card)
        handlePotentialMatch(withCard: card)
    }
    
    func shuffle() {
        deck += board
        board.removeAll()
        selectedCards.removeAll()
        for _ in 0..<12 {
            let randomIndex = deck.count.arc4random
            board.append(deck.remove(at: randomIndex))
        }
    }
    
    init() {
        deck = createDeck()
        var shuffled = [Card]()
        for _ in deck.indices {
            let randomIndex = deck.count.arc4random
            shuffled.append(deck.remove(at: randomIndex))
        }
        deck = shuffled
        assert(deck.count == 81)
        dealCards(numberOfCards: 12)
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(objectsIn elements: Array) {
        for elem in elements {
            if let index = self.index(of: elem) {
                self.remove(at: index)
            }
        }
    }
}


