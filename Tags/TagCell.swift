//
//  TagCell.swift
//  Tags
//
//  Created by Tomasz Kopycki on 15/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var constrBtnDeleteLeading: NSLayoutConstraint!
    
    var mode = NoolTagCellMode.display
    var text: String = "" {
        didSet {
            lblTag.text = text
            
            let value = NoolTagsCommon.leftMargin + text.size(attributes:
                [NSFontAttributeName: NoolTagsCommon.font]).width
            constrBtnDeleteLeading.constant = value
            self.layoutIfNeeded()
        }
        
    }
    var indexPath: IndexPath?
    var delegate: TagCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mode = .display
        lblTag.font = NoolTagsCommon.font
        btnDelete.transform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI_4)
        )
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        
        guard mode == .edit else { return }
        
        if let delegate = delegate, let indexPath = indexPath {
            delegate.tagCellDeleted(at: indexPath)
        }
    }
    
}
