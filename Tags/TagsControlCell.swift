//
//  TagsControlCell.swift
//  Tags
//
//  Created by Tomasz Kopycki on 15/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit

class TagsControlCell: UICollectionViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var cvTags: UICollectionView!
    
    var newTagCellMode = TagCellMode.display
    var newTagText = ""
    
    var mode = TagCellMode.display {
        didSet {
            cvTags.performBatchUpdates({
                if self.mode == .display {
                    if self.cvTags.numberOfItems(inSection: 0) == self.tags.count + 1 {
                        self.cvTags.deleteItems(at: [IndexPath(row: self.tags.count,
                                                               section: 0)])
                    }
                } else {
                    self.cvTags.insertItems(at: [IndexPath(row: self.tags.count, section: 0)])
                }
                
            }, completion: { didFinish in
                if let delegate = self.delegate {
                    delegate.tagsControlNeedsUpdate(height: self.cvTags.contentSize.height)
                }
                self.cvTags.reloadData()
            })
        }
    }
    
    var tags: [String] {
        get {
            if let delegate = delegate {
                return delegate.tagsControlTags()
            }
            return [String]()
        }
        set {
            if let delegate = delegate {
                delegate.tagsControlDidUpdate(tags: newValue)
                delegate.tagsControlNeedsUpdate(height: cvTags.contentSize.height)
            }
        }
    }
    var availableTags: [String] {
        get {
            if let delegate = delegate {
                return delegate.tagsContolAvailableTags()
            }
            return [String]()
        }
    }
    
    var shouldUseOnlyAvailableTags: Bool {
        get {
            if let delegate = delegate {
                return delegate.tagsControlShouldUseOnlyAvailableTags()
            }
            return false
        }
    }
    
    var delegate: TagsControlCellDelegate?
    
    //MARK: - UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var nib = UINib(nibName: CellId.tag, bundle: nil)
        cvTags.register(nib, forCellWithReuseIdentifier: CellId.tag)
        nib = UINib(nibName: CellId.newTag, bundle: nil)
        cvTags.register(nib, forCellWithReuseIdentifier: CellId.newTag)
        
        cvTags.dataSource = self
        cvTags.delegate = self
        
        cvTags.reloadData()
        
        cvTags.backgroundColor = .green
        if let delegate = delegate {
            delegate.tagsControlNeedsUpdate(height: cvTags.contentSize.height)
        }
            
    }
    
}

//MARK: - TagCell & NewTagCell Delegate

extension TagsControlCell: NewTagCellDelegate, TagCellDelegate {
    
    func newTagCellDidChange(mode: TagCellMode) {
        
        newTagCellMode = mode
        cvTags.performBatchUpdates(nil, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControlNeedsUpdate(height: self.cvTags.contentSize.height)
            }
        })
        
    }
    
    func newTagCellDidChange(text: String) {
        
        newTagText = text
        cvTags.performBatchUpdates(nil, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControlNeedsUpdate(height: self.cvTags.contentSize.height)
            }
        })
    }
    
    func newTagCellDidSave() {
        
        tags.append(newTagText)
        
        cvTags.performBatchUpdates({
            self.cvTags.insertItems(at: [IndexPath(row: self.tags.count - 1, section: 0)])
        }, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControlNeedsUpdate(height: self.cvTags.contentSize.height)
            }
        })
        
        newTagCellDidChange(text: "")
    }
    
    func tagCellDeleted(at indexPath: IndexPath) {
        
        tags.remove(at: indexPath.row)
        
        cvTags.performBatchUpdates({ 
            self.cvTags.deleteItems(at: [indexPath])
        }, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControlNeedsUpdate(height: self.cvTags.contentSize.height)
            }
            self.cvTags.reloadData()
        })
    }
}

//MARK: - UICollectionView Delegate & DataSource

extension TagsControlCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tags.count + (mode == .display ? 0 : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if mode == .edit && indexPath.row == tags.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.newTag,
                                                          for: indexPath) as! NewTagCell
            
            cell.delegate = self
            cell.mode = newTagCellMode
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.tag,
                                                      for: indexPath) as! TagCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.mode = mode
        cell.lblTag.text = tags[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if mode == .edit && indexPath.row == tags.count {
            
            if newTagCellMode == .display {
                return CGSize(width: 40, height: 40)
            } else {
                let width = max(90, 45 + newTagText.size(attributes:
                    [NSFontAttributeName: TagCellConstants.font]).width)
                return CGSize(width: width, height: 40)
            }
        }
        
        let tag = tags[indexPath.row]
        
        var width = tag.size(attributes: [NSFontAttributeName: TagCellConstants.font]).width
        width += (mode == .display ? 0 :
            TagCellConstants.buttonWidth) + TagCellConstants.leftMargin
                + TagCellConstants.rightMargin + 10
        
        width = min(width, collectionView.frame.width)
        
        return CGSize(width: width, height: TagCellConstants.height)
        
    }
    
    
}
