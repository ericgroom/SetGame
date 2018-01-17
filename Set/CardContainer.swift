//
//  CardContainer.swift
//  Set
//
//  Created by Eric Groom on 1/11/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

class CardContainer: UIView {
    
    lazy var grid = Grid(layout: .aspectRatio(0.625), frame: self.bounds)
    var cards = [SetCardView]() {
        didSet {
            oldValue.filter { !cards.contains($0) }
                .forEach { view in
                    UIView.transition(
                        with: view,
                        duration: 0.4,
                        options: [.curveEaseInOut],
                        animations: { view.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) },
                        completion: { finished in
                            UIView.transition(
                                with: view,
                                duration: 0.6,
                                options: [.allowAnimatedContent],
                                animations: {
                                    view.alpha = 0
                                    view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            },
                                completion: {finished in view.removeFromSuperview()}
                            )
                    }
                    )
            }
            setNeedsLayout()
        }
    }
    private var horizontalPadding: CGFloat {
        return 50 / CGFloat(cards.count)
    }
    private var verticalPadding: CGFloat {
        return 20 / CGFloat(cards.count)
    }
    
    private var isNewGame: Bool {
        return cards.count == 12 && cards.filter { !$0.isFaceUp }.count == 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = cards.count
        grid.frame = self.bounds
        // used to calculate delay
        var newCardCounter: Double = 0
        for index in 0..<grid.cellCount {
            if let frame = grid[index] {
                if !subviews.contains(cards[index]) {
                    addSubview(cards[index])
                }
                if !cards[index].isFaceUp && !isNewGame {
                    newCardCounter += 1
                }
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: self.cards[index].isFaceUp ? 0 : 0.1 * newCardCounter,
                    options: [.curveEaseInOut],
                    animations: { self.cards[index].frame = frame.insetBy(dx: self.horizontalPadding, dy: self.verticalPadding) },
                    completion: { finished in
                        if index < self.cards.count, !self.cards[index].isFaceUp {
                            UIView.transition(
                                with: self.cards[index],
                                duration: 0.4,
                                options: [.transitionFlipFromLeft],
                                animations: { self.cards[index].isFaceUp = true },
                                completion: nil)
                        } }
                )
            }
        }
    }
}

