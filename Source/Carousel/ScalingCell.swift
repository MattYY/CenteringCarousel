//
//  ScalingCell.swift
//  ScalingCarousel
//
//  Created by Matthew Yannascoli on 10/21/17.
//  Copyright © 2017 RGA. All rights reserved.
//

import UIKit


class ScalingCell: UICollectionViewCell {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let typed = layoutAttributes as? ScaleInFlowAttributes else {
            return
        }
        
        transform = CGAffineTransform(scaleX: typed.scale, y: typed.scale)
    }
}
