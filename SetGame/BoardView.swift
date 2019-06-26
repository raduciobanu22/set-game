//
//  BoardView.swift
//  SetGame
//
//  Created by Radu on 21/06/19.
//  Copyright © 2019 Radu Ciobanu. All rights reserved.
//

import UIKit

@IBDesignable
class BoardView: UIView {
    var cardViews = [CardView]() {
        didSet {
            self.grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(0.725)), frame: frame)
            self.grid!.cellCount = self.cardViews.count
            setupView()
        }
    }
    
    private var grid: Grid?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        for index in cardViews.indices {
            addSubview(cardViews[index])
            let edgeInsets = UIEdgeInsets(top: .zero, left: leftOffset, bottom: bottomOffset, right: .zero)
            cardViews[index].frame = grid![index]!.inset(by: edgeInsets)
        }
    }
}

extension BoardView {
    private struct SizeRatio {
        static let leftOffsetToBoundsWidth: CGFloat = 0.05
        static let bottomOffsetToBoundsHeight: CGFloat = 0.02
    }
    
    private var leftOffset: CGFloat {
        return bounds.width * SizeRatio.leftOffsetToBoundsWidth
    }
    
    private var bottomOffset: CGFloat {
        return bounds.height * SizeRatio.bottomOffsetToBoundsHeight
    }
}
