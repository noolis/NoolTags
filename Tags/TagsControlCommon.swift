//
//  TagsControlCommon.swift
//  Tags
//
//  Created by Tomasz Kopycki on 16/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import Foundation
import UIKit

enum TagCellMode {
    case display, edit
}

protocol TagCellDelegate {
    func tagCellDeleted(at indexPath: IndexPath)
}

protocol TagsControlCellDelegate {
    
    func tagsControlDidUpdate(tags: [String])
    func tagsControlNeedsUpdate(height: CGFloat)
    func tagsContolAvailableTags() -> [String]
    func tagsControlTags() -> [String]
    func tagsControlShouldUseOnlyAvailableTags() -> Bool
}

protocol NewTagCellDelegate {
    
    func newTagCellDidChange(text: String)
    func newTagCellDidChange(mode: TagCellMode)
    func newTagCellDidSave()
}

struct CellId {

    static let tag = "TagCell"
    static let newTag = "NewTagCell"
    static let tagsControl = "TagsControlCell"
}

struct TagCellParams {
    
    static var font = UIFont.systemFont(ofSize: 14)
    static var leftMargin = CGFloat(12)
    static var rightMargin = CGFloat(2)
    static var buttonWidth = CGFloat(36)
    static var height = CGFloat(40)
    
    static var lblTrailingConstantForDisplay = CGFloat(10)
    static var lblTrailingConstantForEdit = CGFloat(50)
    
    static var btnDeleteImage = UIImage()
    static var btnAddImage = UIImage()
}
