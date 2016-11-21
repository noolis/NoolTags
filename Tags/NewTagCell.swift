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
    @IBOutlet weak var tvAutocomplete: UITableView!
    @IBOutlet weak var constrTxfLeading: NSLayoutConstraint!
    
    var delegate: NewTagCellDelegate?
    
    var mode: TagCellMode = .display
    var text = "" {
        didSet {
            if txfTag != nil {
                txfTag.text = text
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txfTag.delegate = self
        txfTag.font = NoolTagsCommon.font
        txfTag.addTarget(self, action: #selector(NewTagCell.textFieldDidChange),
                         for: .editingChanged)
        
        let nib = UINib(nibName: CellId.autocomplete, bundle: nil)
        tvAutocomplete.register(nib, forCellReuseIdentifier: CellId.autocomplete)
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        
        mode = mode == .display ? .edit : .display
        constrTxfLeading.constant = mode == .display ? 0 :
            NoolTagsCommon.newTagTxfLeadingConstraint
        
        UIView.animate(withDuration: 0.3, animations: {
            self.btnAdd.transform = self.btnAdd.transform.rotated(by: CGFloat(M_PI_4))
            self.layoutIfNeeded()
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
        
        text = ""
        
        if let delegate = delegate {
            delegate.newTagCellDidSave()
        }
        
        return true
    }
    
    func textFieldDidChange() {
        
        if let delegate = delegate {
            delegate.newTagCellDidChange(text: txfTag.text!)
        }
    }
    
}
