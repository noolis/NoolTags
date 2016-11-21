//
//  AutocompleteCell.swift
//  Tags
//
//  Created by Tomasz Kopycki on 17/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit

class AutocompleteCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    var title = "" {
        didSet {
            updateHighlight()
        }
    }
    var highlightedTitle = "" {
        didSet {
            updateHighlight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func updateHighlight() {
        
        let grayAttr: [String: AnyObject] = [
            NSFontAttributeName: NoolTagsCommon.font,
            NSForegroundColorAttributeName: UIColor.gray
        ]
        
        let orangeAttr: [String: AnyObject] = [
            NSFontAttributeName: NoolTagsCommon.font,
            NSForegroundColorAttributeName: UIColor.orange
        ]
        
        let attrString = NSMutableAttributedString(string: title, attributes: grayAttr)
        
        var lastFoundIndex = 0
        for char in highlightedTitle.characters {
            
            let nsstring = (title as NSString).substring(from: lastFoundIndex) as NSString
            
            var range = nsstring.range(of: String(char), options: .caseInsensitive)
            
            if range.location != NSNotFound {
                
                range.location += lastFoundIndex
                lastFoundIndex = range.location + 1
                
                attrString.setAttributes(orangeAttr, range: range)
            }
            
        }
        
        lblTitle.attributedText = attrString
    }

}
