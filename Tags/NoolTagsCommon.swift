//
//  NoolTagsCommon.swift
//  Tags
//
//  Created by Tomasz Kopycki on 16/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import Foundation
import UIKit

enum NoolTagCellMode {
    case display, edit
}

protocol TagCellDelegate {
    func tagCellDeleted(at indexPath: IndexPath)
}

protocol NoolTagsDelegate {
    
    func tagsControl(_ tagsControl: NoolTagsVC, didUpdate tags: [String])
    func tagsControl(_ tagsControl: NoolTagsVC, needsUpdate height: CGFloat)
    func tagsControlAvailableTags(_ tagsControl: NoolTagsVC) -> [String]
    func tagsControlTags(_ tagsControl: NoolTagsVC) -> [String]
    func tagsControlShouldUseOnlyAvailableTags(_ tagsControl: NoolTagsVC) -> Bool
    func tagsControl(_ tagsControl: NoolTagsVC, didSelect tag: String)
}

protocol NewTagCellDelegate {
    
    func newTagCellDidChange(text: String)
    func newTagCellDidChange(mode: NoolTagCellMode)
    func newTagCellDidSave()
}

struct NoolCellId {

    static let tag = "TagCell"
    static let newTag = "NewTagCell"
    static let autocomplete = "AutocompleteCell"
}

struct NoolTagsCommon {
    
    static var font = UIFont(name: "Ubuntu", size: 12)!
    static var leftMargin = CGFloat(12)
    static var rightMargin = CGFloat(2)
    static var buttonWidth = CGFloat(30)
    static var cellHeight = CGFloat(30)
    
    static var autocompleteTopMargin = CGFloat(10)
    static var autocompleteRowHeight = CGFloat(20)
    
    static var lblTrailingConstantForDisplay = CGFloat(10)
    static var lblTrailingConstantForEdit = CGFloat(50)
    
    static var newTagTxfLeadingConstraint = CGFloat(12) 
    
}
