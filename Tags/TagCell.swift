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
    @IBOutlet weak var constrLblTagTrailing: NSLayoutConstraint!
    
    var mode = TagCellMode.display {
        didSet {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                let width: CGFloat = self.mode == .display ?
                    TagCellConstants.lblTrailingConstantForDisplay :
                    TagCellConstants.lblTrailingConstantForEdit
                self.constrLblTagTrailing.constant = width
            }
        }
    }
    var indexPath: IndexPath?
    var delegate: TagCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mode = .display
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        
        if let delegate = delegate, let indexPath = indexPath {
            delegate.tagCellDeleted(at: indexPath)
        }
    }
    
}
