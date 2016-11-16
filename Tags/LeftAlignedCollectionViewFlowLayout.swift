//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Tags
//
//  Created by Tomasz Kopycki on 16/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        minimumInteritemSpacing = 2.0
        minimumLineSpacing = 2.0
        sectionInset = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        minimumInteritemSpacing = 2.0
        minimumLineSpacing = 2.0
        sectionInset = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
