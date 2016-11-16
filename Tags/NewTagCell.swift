//
//  NewTagCell.swift
//  Tags
//
//  Created by Tomasz Kopycki on 15/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit

class NewTagCell: UICollectionViewCell {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txfTag: UITextField!
    
    var delegate: NewTagCellDelegate?
    
    var mode: TagCellMode = .display
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txfTag.delegate = self
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        
        mode = mode == .display ? .edit : .display
        
        UIView.animate(withDuration: 0.2, animations: {
            self.btnAdd.transform = self.btnAdd.transform.rotated(by: CGFloat(M_PI_4))
        })
        
        if let delegate = delegate {
            delegate.newTagCellDidChange(mode: mode)
        }
        
        if mode == .edit {
            txfTag.becomeFirstResponder()
        } else {
            txfTag.resignFirstResponder()
        }
    }
}

extension NewTagCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        
        if let delegate = delegate {
            delegate.newTagCellDidSave()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let delegate = delegate {
            delegate.newTagCellDidChange(text: textField.text! + string)
        }
        
        return true
    }
    
}
