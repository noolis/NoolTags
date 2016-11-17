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
            NSFontAttributeName: TagCellParams.font,
            NSForegroundColorAttributeName: UIColor.gray
        ]
        
        let attrString = NSMutableAttributedString(string: title, attributes: grayAttr)
        
        let range = (title as NSString).range(of: highlightedTitle)
        
        let orangeAttr: [String: AnyObject] = [
            NSFontAttributeName: TagCellParams.font,
            NSForegroundColorAttributeName: UIColor.orange
        ]
        
        attrString.setAttributes(orangeAttr, range: range)
        
        lblTitle.attributedText = attrString
    }

}
