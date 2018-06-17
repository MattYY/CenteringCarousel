//
//  DynamicAnimatorLayout.swift
//  ScalingCarousel
//
//  Created by Matthew Yannascoli on 10/30/17.
//  Copyright © 2017 RGA. All rights reserved.
//

import UIKit

class DynamicAnimatorLayout: UICollectionViewFlowLayout {
    var animator: UIDynamicAnimator?
    
    override init() {
        super.init()
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        itemSize = CGSize(width: 44, height: 44)
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        animator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        let size = collectionViewContentSize
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let items = super.layoutAttributesForElements(in: rect) ?? []
        
        guard animator?.behaviors.count == 0 else {
            return
        }
        
        items.forEach {
            item in
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            behavior.length = 0
            behavior.damping = 0.8
            behavior.frequency = 1.0
            
            animator?.addBehavior(behavior)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //return super.layoutAttributesForElements(in: rect)
        return animator?.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator?.layoutAttributesForCell(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView, let animator = animator else {
            return false
        }
        
        let dy = newBounds.origin.y - cv.bounds.origin.y
        let touchPoint = collectionView?.panGestureRecognizer.location(in: cv) ?? CGPoint.zero
        
        for behavior in animator.behaviors {
            guard let attachment = behavior as? UIAttachmentBehavior else {
                continue
            }
            
            let yDistance = abs(touchPoint.y - attachment.anchorPoint.y)
            let xDistance = abs(touchPoint.x - attachment.anchorPoint.x)
            let resistance = (yDistance + xDistance)/500
            
            guard let item = attachment.items.first else {
                continue
            }
            
            if dy < 0 {
                item.center.y += max(dy, resistance * dy)
            }
            else {
                item.center.y += min(dy, resistance * dy)
            }
            
            animator.updateItem(usingCurrentState: item)
        }

        return false
    }
}
