//
//  CardView.swift
//  SetGame
//
//  Created by Radu on 21/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    var color: UIColor = UIColor.purple
    var shape: Shape = .squiggle
    var style: Style = .striped
    var total: Int = 3
    var isSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        if !isHidden {
            let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius)
            if isSelected {
                roundedRect.lineWidth = 3.0
            }
            let color = (isSelected) ? UIColor.red : UIColor.black
            color.setStroke()
            roundedRect.stroke()
            roundedRect.close()
            
            drawShapes()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func setupView() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func drawShapes() {
        let context = UIGraphicsGetCurrentContext()
        for index in 0..<total {
            let path = getShapePathAtIndex(index)
            switch style {
            case .filled:
                color.setFill()
                path.fill()
            case .outline:
                color.setStroke()
                path.stroke()
            case .striped:
                context?.saveGState()
                path.addClip()
                color.setStroke()
                path.stroke()
                let stripes = UIBezierPath()
                color.setStroke()
                for start in stride(from: Int(shapeLeftOffset), through: Int(shapeLeftOffset + shapeWidth), by: Int(stripesSpacing))  {
                    stripes.move(to: CGPoint(x: CGFloat(start), y: path.bounds.minY))
                    stripes.addLine(to: CGPoint(x: CGFloat(start), y: path.bounds.minY + path.bounds.height))
                }
                
                stripes.stroke()
                context?.restoreGState()
            }
        }
    }
    
    private func getShapePathAtIndex(_ index: Int) -> UIBezierPath {
        let topOffset = (bounds.height - (shapeHeight * CGFloat(total)) - shapeSpacing * CGFloat(total - 1)) / 2 + CGFloat(index) * (shapeHeight + shapeSpacing)
        switch shape {
        case .oval:
            let rectangle = CGRect(x: shapeLeftOffset, y: topOffset, width: shapeWidth, height: shapeHeight)
            let path = UIBezierPath(roundedRect: rectangle, cornerRadius: ovalCornerRadius)
            return path
        
        case .diamond:
            let path = UIBezierPath()
            let midPoint = topOffset + shapeHeight / 2
            path.move(to: CGPoint(x: shapeLeftOffset, y: midPoint))
            path.addLine(to: CGPoint(x: bounds.midX, y: midPoint - (shapeHeight / 2)))
            path.addLine(to: CGPoint(x: bounds.maxX - shapeLeftOffset, y: midPoint))
            path.addLine(to: CGPoint(x: bounds.midX, y: midPoint + (shapeHeight / 2)))
            path.close()
            return path
        
        case .squiggle:
            let path = UIBezierPath()
            let midPoint = topOffset + shapeHeight / 2
            path.move(to: CGPoint(x: shapeLeftOffset + 0.15 * shapeWidth, y: midPoint + shapeHeight / 2))
            
            path.addQuadCurve(to: CGPoint(x: shapeLeftOffset + shapeWidth / 2, y: midPoint - shapeHeight / 4), controlPoint: CGPoint(x: bounds.minX, y: midPoint - 0.8 * shapeHeight))
            path.addQuadCurve(to: CGPoint(x: shapeLeftOffset + 0.8 * shapeWidth, y: midPoint - shapeHeight / 2), controlPoint: CGPoint(x: shapeLeftOffset + 0.66 * shapeWidth, y: midPoint))
            path.addQuadCurve(to: CGPoint(x: bounds.maxX - shapeLeftOffset - shapeWidth / 2, y: midPoint + shapeHeight / 4), controlPoint: CGPoint(x: bounds.maxX, y: midPoint + 0.8 * shapeHeight))
            path.addQuadCurve(to: CGPoint(x: shapeLeftOffset + 0.15 * shapeWidth, y: midPoint + shapeHeight / 2), controlPoint: CGPoint(x: shapeLeftOffset + shapeWidth / 4, y: midPoint))
            return path
        }
    }
}

extension CardView {
    private struct SizeRatio {
        static let shapeWidthToBoundsWidth: CGFloat = 0.80
        static let shapeHeightToBoundsHeight: CGFloat = 0.20
        static let shapeLeftOffsetToBoundsWidth: CGFloat = 0.10
        static let betweenShapesOffsetToBoundsHeight: CGFloat = 0.05
        static let ovalCornerRadius: CGFloat = 0.25
        static let stripesSpacingToBoundsWidth: CGFloat = 0.05
        static let cardCornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    enum Shape {
        case diamond, oval, squiggle
    }
    
    enum Style {
        case filled, outline, striped
    }
    
    private var shapeWidth: CGFloat {
        return bounds.size.width * SizeRatio.shapeWidthToBoundsWidth
    }
    
    private var shapeHeight: CGFloat {
        return bounds.size.height * SizeRatio.shapeHeightToBoundsHeight
    }
    
    private var shapeLeftOffset: CGFloat {
        return bounds.size.width * SizeRatio.shapeLeftOffsetToBoundsWidth
    }
    
    private var ovalCornerRadius: CGFloat {
        return bounds.size.width * SizeRatio.ovalCornerRadius
    }
    
    private var shapeSpacing: CGFloat {
        return bounds.size.height * SizeRatio.betweenShapesOffsetToBoundsHeight
    }
    
    private var stripesSpacing: CGFloat {
        return bounds.size.width * SizeRatio.stripesSpacingToBoundsWidth
    }
    
    private var cardCornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cardCornerRadiusToBoundsHeight
    }
}
