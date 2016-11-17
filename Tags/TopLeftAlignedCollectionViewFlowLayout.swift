//
//  TopLeftAlignedCollectionViewFlowLayout.swift
//  Tags
//
//  Created by Tomasz Kopycki on 16/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit


class TopLeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
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
        
        var i = 0
        var lastTopAlignedIndex = -5
        var previousY = sectionInset.top
        
        attributes?.forEach { layoutAttribute in
            
            i+=1
            
            if layoutAttribute.frame.origin.y > maxY {
                
                leftMargin = sectionInset.left
                
                if previousY + layoutAttribute.frame.height + minimumLineSpacing < layoutAttribute.frame.origin.y {
                    lastTopAlignedIndex = i
                    layoutAttribute.frame.origin.y = previousY + layoutAttribute.frame.height + minimumLineSpacing
                }
            }
            
            if lastTopAlignedIndex == i - 1 {
                layoutAttribute.frame.origin.y = previousY
                lastTopAlignedIndex = i
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
            
            previousY = layoutAttribute.frame.origin.y
        }
        
        return attributes
    }
}
