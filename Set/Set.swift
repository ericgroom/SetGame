//
//  Set.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import Foundation

class Set {
    private var deck = [Card]()
    private(set) var board = [Card]() {
        didSet {
            assert(board.count <= 24, "Set.board: board cannot contain more than 24 cards")
        }
    }
    var canDealMoreCards: Bool {
        let matchesThatCanBeRemoved = board.filter { matchedCards.contains($0) }
        let occupiedSpacesOnBoard = board.count - matchesThatCanBeRemoved.count
        let freeSpaces = 24 - occupiedSpacesOnBoard
        let cardsRemaining = deck.count
        return cardsRemaining != 0 && freeSpaces >= 3
    }
    
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    var currentSelectionIsMatch: Bool?
    
    private(set) var score = 0
    
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
    
    func dealCards(numberOfCards: Int = 3) {
        if numberOfCards + board.count > 24 {
            board = board.filter { !matchedCards.contains($0) }
        }
        if deck.count >= numberOfCards {
            let range = 0..<numberOfCards
            board.append(contentsOf: deck[range])
            deck.removeSubrange(range)
            assert(board.count <= 24, "Set.dealCards(): there can't be more than 24 cards on the board but \(board.count) are")
        }
    }
    
    func cardChosen(index: Int) {
        if index > board.count - 1 {
            return
        }
        let card = board[index]
        if matchedCards.contains(card) {
            return
        }
        if selectedCards.count == 3 {
            if Card.doesMakeSet(selectedCards) {
                matchedCards += selectedCards
                selectedCards.removeAll()
                score += 3
                currentSelectionIsMatch = true
                dealCards()
            } else {
                currentSelectionIsMatch = false
                selectedCards.removeAll()
                score -= 5
            }
        } else {
            currentSelectionIsMatch = nil
        }
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
        } else {
            if !matchedCards.contains(card) {
                selectedCards.append(card)
            }
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
