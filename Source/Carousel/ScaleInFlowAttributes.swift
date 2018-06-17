//
//  ScaleInFlowAttributes.swift
//  ScalingCarousel
//
//  Created by Matthew Yannascoli on 10/21/17.
//  Copyright © 2017 RGA. All rights reserved.
//

import UIKit

class ScaleInFlowAttributes: UICollectionViewLayoutAttributes {
    var scale: CGFloat = 1.0 {
        didSet {
            transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let attributes = super.copy(with: zone) as? ScaleInFlowAttributes else {
            return ScaleInFlowAttributes()
        }
        
        attributes.scale = self.scale
        return attributes
    }
}
