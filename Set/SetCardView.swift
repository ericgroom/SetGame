//
//  SetCard.swift
//  Set
//
//  Created by Eric Groom on 1/9/18.
//  Copyright © 2018 Eric Groom. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    var symbol: Symbol = .squiggle { didSet { setNeedsDisplay() }}
    var shading: Shading = .striped { didSet { setNeedsDisplay() }}
    var quantity: Quantity = .three { didSet { setNeedsDisplay() }}
    var color: Color = .purple { didSet { setNeedsDisplay() }}
    var isSelected: Bool = false { didSet { setNeedsDisplay() }}
    var isFaceUp: Bool = false { didSet { setNeedsDisplay() }}
    
    static var deckPosition: CGRect?
    
    private struct SizeConstants {
        static let cardCornerRadius: CGFloat = 8.0
        static let selectedLineWidth: CGFloat = 4
        static let shapeAspectRatio: (CGFloat, CGFloat) = (5, 2)
        static let shapeLineWidth: CGFloat = 2
        static let shapeHeightToCardHeightRatio: CGFloat = 0.05
        static let shapeWidthToCardWidthRatio: CGFloat = 0.8
        static let stripedNumberOfLinesInEachDirection = 5
        static let stripedLineWidth: CGFloat = 0.5
        static let squiggleArcHeightRatio: CGFloat = 0.10
        static let squiggleHeightRatio: CGFloat = 0.4
    }
    
    private var shapeWidth: CGFloat {
        return bounds.width * SizeConstants.shapeWidthToCardWidthRatio
    }
    private var shapeHeight: CGFloat {
        let (widthRatio, heightRatio) = SizeConstants.shapeAspectRatio
        return shapeWidth / widthRatio * heightRatio
    }
    private var shapePadding: CGFloat {
        return bounds.height * SizeConstants.shapeHeightToCardHeightRatio
    }
    
    private var squiggleCurve: CGFloat {
        return bounds.height * SizeConstants.squiggleArcHeightRatio
    }


    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: SizeConstants.cardCornerRadius)
        roundedRect.addClip()
        if isFaceUp {
            UIColor.white.setFill()
            roundedRect.fill()
        } else {
            #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setFill()
            roundedRect.fill()
            return
        }
        
        if isSelected {
            UIColor.blue.setStroke()
            roundedRect.lineWidth = SizeConstants.selectedLineWidth
            roundedRect.stroke()
        }
        if isFaceUp {
            switch color {
            case .red:
                UIColor.red.setStroke()
                UIColor.red.setFill()
            case .purple:
                UIColor.purple.setStroke()
                UIColor.purple.setFill()
            case .green:
                UIColor.green.setStroke()
                UIColor.green.setFill()
            }
            let shapes: [UIBezierPath]!
            switch symbol {
            case .oval:
                shapes = drawMultipleShapes(number: quantity, usingFunction: drawOval)
            case .diamond:
                shapes = drawMultipleShapes(number: quantity, usingFunction: drawDiamond)
            case .squiggle:
                shapes = drawMultipleShapes(number: quantity, usingFunction: drawSquiggle)
            }
            
            switch shading {
            case .open:
                for shape in shapes {
                    shape.lineWidth = SizeConstants.shapeLineWidth
                    shape.stroke()
                }
            case .fill:
                for shape in shapes {
                    shape.fill()
                }
            case .striped:
                for shape in shapes {
                    shape.lineWidth = SizeConstants.shapeLineWidth
                    shape.stroke()
                    let context = UIGraphicsGetCurrentContext()
                    context?.saveGState()
                    shape.addClip()
                    
                    let noOfLines = SizeConstants.stripedNumberOfLinesInEachDirection
                    let xOffset = shape.bounds.width / CGFloat(noOfLines)
                    let initLowerLeftPoint = CGPoint(x: shape.bounds.minX, y: shape.bounds.maxY)
                    let initUpperRightPoint = CGPoint(x: shape.bounds.maxX, y: shape.bounds.minY)
                    for index in 0..<noOfLines {
                        let positiveLowerLeftPoint = initLowerLeftPoint.offsetBy(x: CGFloat(index) * xOffset, y: 0)
                        let positiveUpperRightPoint = initUpperRightPoint.offsetBy(x: CGFloat(index) * xOffset, y: 0)
                        let positiveLine = UIBezierPath(lineBetween: (positiveLowerLeftPoint, positiveUpperRightPoint))
                        positiveLine.lineWidth = SizeConstants.stripedLineWidth
                        positiveLine.stroke()
                        
                        let negativeLowerLeftPoint = initLowerLeftPoint.offsetBy(x: CGFloat(index) * -xOffset, y: 0)
                        let negativeUpperRightPoint = initUpperRightPoint.offsetBy(x: CGFloat(index) * -xOffset, y: 0)
                        let negativeLine = UIBezierPath(lineBetween: (negativeLowerLeftPoint, negativeUpperRightPoint))
                        negativeLine.lineWidth = SizeConstants.stripedLineWidth
                        negativeLine.stroke()
                    }
                    
                    context?.restoreGState()
                    
                }
            }
        } 
    }
    
    private func drawOval(atOrigin origin: CGPoint) -> UIBezierPath {
        let height = shapeHeight
        let size = CGSize(width: shapeWidth, height: height)
        let origin = CGPoint(x: origin.x - (shapeWidth / 2), y: origin.y - (height / 2))
        let rect = CGRect(origin: origin, size: size)
        let oval = UIBezierPath(ovalIn: rect)
        return oval
    }
    
    private func drawDiamond(atOrigin origin: CGPoint) -> UIBezierPath {
        let diamond = UIBezierPath()
        let left = CGPoint(x: origin.x - shapeWidth / 2, y: origin.y)
        let top = CGPoint(x: bounds.midX, y: origin.y - shapeHeight / 2)
        let right = CGPoint(x: origin.x + shapeWidth / 2, y: origin.y)
        let bottom = CGPoint(x: bounds.midX, y: origin.y + shapeHeight / 2)
        diamond.move(to: left)
        diamond.addLine(to: top)
        diamond.addLine(to: right)
        diamond.addLine(to: bottom)
        diamond.close()
        return diamond
    }
    
    private func drawSquiggle(atOrigin origin: CGPoint) -> UIBezierPath {
        let squiggle = UIBezierPath()
        let shapeHeight = SizeConstants.squiggleHeightRatio * self.shapeHeight
        let lowerLeft = CGPoint(x: origin.x - shapeWidth / 2, y: origin.y + shapeHeight)
        let lowerRight = CGPoint(x: origin.x + shapeWidth / 2, y: origin.y + shapeHeight)
        let lowerCenter = CGPoint(x: origin.x, y: origin.y + shapeHeight)
        let upperLeft = CGPoint(x: origin.x - shapeWidth / 2, y: origin.y - shapeHeight)
        let upperRight = CGPoint(x: origin.x + shapeWidth / 2, y: origin.y - shapeHeight)
        let upperCenter = CGPoint(x: origin.x, y: origin.y - shapeHeight)
        squiggle.move(to: lowerLeft)
        squiggle.addQuadCurve(to: lowerCenter, controlPoint: CGPoint(x: origin.x - shapeWidth / 4, y: origin.y + shapeHeight - squiggleCurve))
        squiggle.addQuadCurve(to: lowerRight, controlPoint: CGPoint(x: origin.x + shapeWidth / 4, y: origin.y + shapeHeight + squiggleCurve))
        squiggle.addLine(to: upperRight)
        squiggle.addQuadCurve(to: upperCenter, controlPoint: CGPoint(x: origin.x + shapeWidth / 4, y: origin.y - shapeHeight + squiggleCurve))
        squiggle.addQuadCurve(to: upperLeft, controlPoint: CGPoint(x: origin.x - shapeWidth / 4, y: origin.y - shapeHeight - squiggleCurve))
        squiggle.close()
        
        return squiggle
    }
    
    private func drawMultipleShapes(number: Quantity, usingFunction function: (CGPoint) -> UIBezierPath) -> [UIBezierPath] {
        var shapes: [UIBezierPath]!
        switch number {
        case .one:
            let shape = function(CGPoint(x: bounds.midX, y: bounds.midY))
            shapes = [shape]
        case .two:
            let yOffset = shapeHeight / 2 + shapePadding / 2
            let upperShape = function(CGPoint(x: bounds.midX, y: bounds.midY - yOffset))
            let lowerShape = function(CGPoint(x: bounds.midX, y: bounds.midY + yOffset))
            shapes = [upperShape, lowerShape]
        case .three:
            let middleShape = function(CGPoint(x: bounds.midX, y: bounds.midY))
            let topOrigin = CGPoint(x: bounds.midX, y: bounds.midY - shapeHeight - shapePadding)
            let upperShape = function(topOrigin)
            let bottomOrigin = CGPoint(x: bounds.midX, y: bounds.midY + shapeHeight + shapePadding)
            let lowerShape = function(bottomOrigin)
            shapes = [middleShape, upperShape, lowerShape]
        }
        return shapes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .redraw
        self.isOpaque = false
    }
    
    convenience init(symbol: Symbol, quantity: Quantity, shading: Shading, color: Color) {
        self.init(frame: SetCardView.deckPosition ?? CGRect.zero)
        self.symbol = symbol
        self.quantity = quantity
        self.shading = shading
        self.color = color
    }

    enum Symbol: String {
        case diamond, squiggle, oval
    }
    
    enum Quantity: Int {
        case one = 1, two, three
    }
    
    enum Shading: String {
        case fill, striped, open
    }
    
    enum Color: String {
        case red, green, purple
    }

}

extension CGPoint {
    func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

extension UIBezierPath {
    convenience init(lineBetween points: (CGPoint, CGPoint)) {
        self.init()
        self.move(to: points.0)
        self.addLine(to: points.1)
    }
}
