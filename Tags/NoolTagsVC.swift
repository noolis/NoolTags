//
//  TagsControlCell.swift
//  Tags
//
//  Created by Tomasz Kopycki on 15/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit



class NoolTagsVC: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var cvTags: UICollectionView!
    
    var newTagCell: NewTagCell?
    var newTagCellMode = NoolTagCellMode.display
    var newTagText = ""
    
    var modeUpdateBlock = false
    
    var mode = NoolTagCellMode.display {
        didSet {
            
            guard modeUpdateBlock == false, cvTags != nil else { return }
            
            modeUpdateBlock = true
            if mode == .display {
                newTagCellMode = .display
            }
            
            cvTags.performBatchUpdates({
                if self.mode == .display {
                    if self.cvTags.numberOfItems(inSection: 0) == self.tags.count + 1 {
                        self.cvTags.deleteItems(at: [IndexPath(row: self.tags.count,
                                                               section: 0)])
                    }
                } else {
                    if self.cvTags.numberOfItems(inSection: 0) == self.tags.count {
                        self.cvTags.insertItems(at: [IndexPath(row: self.tags.count, section: 0)])
                    }
                }
                
            }, completion: { didFinish in
                if let delegate = self.delegate {
                    delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
                }
                self.cvTags.reloadData()
                self.modeUpdateBlock = false
            })
        }
    }
    
    var tags: [String] {
        get {
            if let delegate = delegate {
                return delegate.tagsControlTags(self)
            }
            return [String]()
        }
        set {
            if let delegate = delegate {
                delegate.tagsControl(self, didUpdate: newValue)
                delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
            }
        }
    }
    var availableTags: [String] {
        get {
            if let delegate = delegate {
                return delegate.tagsControlAvailableTags(self)
            }
            return [String]()
        }
    }
    
    var shouldUseOnlyAvailableTags: Bool {
        get {
            if let delegate = delegate {
                return delegate.tagsControlShouldUseOnlyAvailableTags(self)
            }
            return false
        }
    }
    
    var delegate: NoolTagsDelegate?
    
    var autocompleteResults: [String] {
        get {
            let notUsedTags = availableTags.filter { !tags.contains($0) }
            return notUsedTags.filter { $0.fuzzySearch(stringToSearch: newTagText) }
        }
    }
    
    var tvAutocomplete: UITableView?
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode = .display
        
        var nib = UINib(nibName: NoolCellId.tag, bundle: nil)
        cvTags.register(nib, forCellWithReuseIdentifier: NoolCellId.tag)
        nib = UINib(nibName: NoolCellId.newTag, bundle: nil)
        cvTags.register(nib, forCellWithReuseIdentifier: NoolCellId.newTag)
        
        cvTags.dataSource = self
        cvTags.delegate = self
        
        cvTags.reloadData()
        
        if let delegate = delegate {
            delegate.tagsControl(self, needsUpdate: cvTags.contentSize.height)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cvTags.reloadData()
        
        if let delegate = delegate {
            delegate.tagsControl(self, needsUpdate: cvTags.contentSize.height)
        }
        
    }
    
}

//MARK: - TagCell & NewTagCell Delegate

extension NoolTagsVC: NewTagCellDelegate, TagCellDelegate {
    
    func newTagCellDidChange(mode: NoolTagCellMode) {
        
        newTagCellMode = mode
        cvTags.performBatchUpdates(nil, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
            }
        })
        
    }
    
    func newTagCellDidChange(text: String) {
        
        newTagText = text
        newTagCell?.text = newTagText
        tvAutocomplete?.reloadData()
        cvTags.performBatchUpdates(nil, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
            }
        })
    }
    
    func newTagCellDidSave() {
        
        if (shouldUseOnlyAvailableTags && !availableTags.contains(newTagText)) ||
            tags.contains(newTagText) || newTagText.characters.count == 0 {
            
            return
        }
        
        tags.append(newTagText)
        
        cvTags.performBatchUpdates({
            self.cvTags.insertItems(at: [IndexPath(row: self.tags.count - 1, section: 0)])
        }, completion: { didComplete in
            
            if let delegate = self.delegate {
                delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
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
                delegate.tagsControl(self, needsUpdate: self.cvTags.contentSize.height)
            }
            self.cvTags.reloadData()
        })
    }
}

//MARK: - UICollectionView Delegate & DataSource

extension NoolTagsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoolCellId.newTag,
                                                          for: indexPath) as! NewTagCell
            
            newTagCell = cell
            cell.delegate = self
            cell.mode = newTagCellMode
            cell.txfTag.text = ""
            tvAutocomplete = cell.tvAutocomplete
            tvAutocomplete?.delegate = self
            tvAutocomplete?.dataSource = self
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoolCellId.tag,
                                                      for: indexPath) as! TagCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.mode = mode
        cell.text = tags[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if mode == .edit && indexPath.row == tags.count {
            
            if newTagCellMode == .display {
                return CGSize(width: NoolTagsCommon.cellHeight,
                              height: NoolTagsCommon.cellHeight)
            } else {
                
                var longestTextWidth = newTagText.size(attributes:
                    [NSFontAttributeName: NoolTagsCommon.font]).width
                
                for result in autocompleteResults {
                    
                    longestTextWidth = max(longestTextWidth,
                                           result.size(attributes:
                                            [NSFontAttributeName: NoolTagsCommon.font]).width)
                }
                
                let width = max(102, min(52 + longestTextWidth, collectionView.frame.width))
                
                var height = NoolTagsCommon.cellHeight
                
                if newTagText.characters.count > 0 && autocompleteResults.count > 0 {
                    height += CGFloat(autocompleteResults.count) * NoolTagsCommon.autocompleteRowHeight
                }
                
                return CGSize(width: width, height: height)
            }
        }
        
        let tag = tags[indexPath.row]
        
        var width = tag.size(attributes: [NSFontAttributeName: NoolTagsCommon.font]).width
        width += (mode == .display ? NoolTagsCommon.lblTrailingConstantForDisplay :
            NoolTagsCommon.buttonWidth) + NoolTagsCommon.leftMargin
            + NoolTagsCommon.rightMargin
        
        width = min(width, collectionView.frame.width)
        
        return CGSize(width: width, height: NoolTagsCommon.cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            delegate?.tagsControl(self, didSelect: tags[indexPath.row])
        }
    }
}

//MARK: - UITableView DataSource & Delegate

extension NoolTagsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NoolCellId.autocomplete)
            as! AutocompleteCell
        
        cell.title = autocompleteResults[indexPath.row]
        cell.highlightedTitle = newTagText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoolTagsCommon.autocompleteRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newTagText = autocompleteResults[indexPath.row]
        newTagCellDidSave()
        newTagCell?.text = newTagText
    }
    
}
