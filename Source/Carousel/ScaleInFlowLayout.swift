//
//  ScaleInFlowLayout.swift
//  ScalingCarousel
//
//  Created by Matthew Yannascoli on 10/21/17.
//  Copyright © 2017 RGA. All rights reserved.
//

import UIKit

class ScaleInFlowLayout: UICollectionViewLayout {
    struct Constants {
        static let LoadBufferCount: Int = 5
    }
    
    var attributes: [ScaleInFlowAttributes] = []
    var itemSpacing: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    
    var maxScale: CGFloat = 1.3 {
        didSet {
            invalidateLayout()
        }
    }
    
    var itemSize: CGSize = CGSize.zero {
        didSet {
            invalidateLayout()
        }
    }
}

extension ScaleInFlowLayout {
    override func prepare() {
        guard itemSize != CGSize.zero else {
            self.attributes = []
            return
        }
        
        self.attributes = (minRow..<maxRow).map {
            return attribute(for: $0)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        
        let rowCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        let totalItemWidth = (rowCount - 1) * itemSize.width
        let totalSpacingWidth = (rowCount - 1) * itemSpacing
        let total = totalItemWidth + totalSpacingWidth + collectionView.frame.width
        
        return CGSize(width: total, height: collectionView.bounds.height)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }
        
        let currentRowIndex = Int(proposedContentOffset.x/collectionView.contentSize.width)
        print("x: \(proposedContentOffset.x), velocity: \(velocity)")
        
        return proposedContentOffset
        
//        if velocity.x > 0 {
//            return itemPosition(for: currentRowIndex + 1)
//        }
//        else {
//            return itemPosition(for: currentRowIndex - 1)
//        }
    }
    
    override class var layoutAttributesClass: AnyClass {
        return ScaleInFlowLayout.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension ScaleInFlowLayout {
    fileprivate var minRow: Int {
        let offset = collectionView?.contentOffset.x ?? 0
        let minRow = Int(floor(offset/itemSize.width))
        return max(minRow - Constants.LoadBufferCount, 0)
    }
    
    fileprivate var maxRow: Int {
        let totalRowCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        let width = collectionView?.bounds.width ?? 0
        let maxRow = minRow + Int(ceil(width/itemSize.width))
        
        return min(maxRow + Constants.LoadBufferCount, totalRowCount)
    }
    
    fileprivate func attribute(for row: Int) -> ScaleInFlowAttributes {
        let indexPath = IndexPath(row: row, section: 0)
        let a = ScaleInFlowAttributes(forCellWith: indexPath)
        
        let itemCenterPoint = itemPosition(for: row)
        let scale: CGFloat = 1
        
        a.zIndex = Int(scale * 1000)
        a.scale = scale
        a.size = itemSize
        a.center = itemCenterPoint
        return a
    }

    fileprivate func itemPosition(for row: Int) -> CGPoint {
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }
        
        let spacingWidth = itemSpacing * CGFloat(row)
        let viewCenterX = collectionView.frame.width/2.0
        
        let x = CGFloat(row) * itemSize.width + spacingWidth + viewCenterX//+ marginWidth + viewCenterX
        let y = collectionView.center.y
        
        return CGPoint(x: x, y: y)
    }
}
