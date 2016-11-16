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

struct TagCellConstants {
    
    static let font = UIFont.systemFont(ofSize: 16)
    static let leftMargin = CGFloat(4)
    static let rightMargin = CGFloat(12)
    static let buttonWidth = CGFloat(35)
    static let height = CGFloat(40)
    
    static let lblTrailingConstantForDisplay = CGFloat(10)
    static let lblTrailingConstantForEdit = CGFloat(50)
    
}
