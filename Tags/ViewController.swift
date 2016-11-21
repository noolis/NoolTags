//
//  ViewController.swift
//  Tags
//
//  Created by Tomasz Kopycki on 15/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var btnEditDisplay: UIButton!
    @IBOutlet weak var cvContent: UICollectionView!
    
    var mode = NoolTagCellMode.display
    var onlyAvailableTags = false
    var tags = ["First tag", "Second tag", "Third tag", "Fourth tag", "Really long long tag"]
    var availableTags = ["First tag", "Second tag", "Third tag", "Fourth tag",
                         "Really long long tag", "Tag 6", "Tag 7", "Tag 8", "Tomek jest super"]
    var tagsControlHeight: CGFloat = 46
    
    var tagsVC: NoolTagsVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsVC = NoolTagsVC(nibName: "NoolTagsVC", bundle: nil)
        tagsVC?.delegate = self
        
        let nib = UINib(nibName: "TagsCell", bundle: nil)
        cvContent.register(nib, forCellWithReuseIdentifier: "TagsCell")
        
        cvContent.delegate = self
        cvContent.dataSource = self
    }
    
    //MARK: - IBActions
    
    @IBAction func btnEditDisplayTapped(_ sender: Any) {
        
        mode = (mode == .display ? .edit : .display)
        self.cvContent.reloadData()
    }
    
    @IBAction func btnResetTapped(_ sender: Any) {
    }
    
    @IBAction func btnAvailableTagesTapped(_ sender: Any) {
        
        onlyAvailableTags = !onlyAvailableTags
    }
    
}

extension ViewController: NoolTagsDelegate {
    
    func tagsControlDidUpdate(tags: [String]) {
        self.tags = tags
    }
    
    func tagsControlNeedsUpdate(height: CGFloat) {
        
        tagsControlHeight = height
        cvContent.performBatchUpdates(nil, completion: nil)
    }
    
    func tagsControlAvailableTags() -> [String] {
        return availableTags
    }
    
    func tagsControlTags() -> [String] {
        return tags
    }
    
    func tagsControlShouldUseOnlyAvailableTags() -> Bool {
        return onlyAvailableTags
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCell",
                                                      for: indexPath) as! TagsCell
        
        tagsVC?.mode = mode
        
        if let view = tagsVC?.view, !cell.subviews.contains(view) {
            cell.addSubview(view)
            
            cell.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|",
                                               options: [], metrics: nil,
                                               views: ["view": view]))
            cell.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                               options: [], metrics: nil,
                                               views: ["view": view]))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvContent.frame.width, height: tagsControlHeight)
    }
    
}

