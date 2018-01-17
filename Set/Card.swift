//
//  Card.swift
//  Set
//
//  Created by Eric Groom on 1/8/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import Foundation

struct Card : Hashable {
    
    var hashValue: Int {
        return self.identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let symbol: Int
    let color: Int
    let shading: Int
    let quantity: Int
    
    private let identifier: Int
    private static var previousIdentifier = 0
    private static func generateUid() -> Int {
        previousIdentifier += 1
        return previousIdentifier
    }
    
    init(symbol: Int, color: Int, shading: Int, quantity: Int) {
        self.symbol = symbol
        self.color = color
        self.shading = shading
        self.quantity = quantity
        self.identifier = Card.generateUid()
    }
    
    static func doesMakeSet(_ cards: [Card]) -> Bool {
        let match: (Int, Int, Int) -> Bool = { $0 == $1 && $1 == $2 }
        let mismatch: (Int, Int, Int) -> Bool = { $0 != $1 && $1 != $2 && $0 != $2 }
        let colorsMatch = match(cards[0].color, cards[1].color, cards[2].color)
        let colorsMismatch = mismatch(cards[0].color, cards[1].color, cards[2].color)
        let shadingMatch = match(cards[0].shading, cards[1].shading, cards[2].shading)
        let shadingMismatch = mismatch(cards[0].shading, cards[1].shading, cards[2].shading)
        let quantitiesMatch = match(cards[0].quantity, cards[1].quantity, cards[2].quantity)
        let quantitiesMismatch = mismatch(cards[0].quantity, cards[1].quantity,cards[2].quantity)
        let symbolsMatch = match(cards[0].symbol, cards[1].symbol, cards[2].symbol)
        let symbolsMismatch = mismatch(cards[0].symbol, cards[1].symbol, cards[2].symbol)
        return (colorsMatch || colorsMismatch) && (shadingMatch || shadingMismatch) && (quantitiesMatch || quantitiesMismatch) && (symbolsMatch || symbolsMismatch)
    }
}

