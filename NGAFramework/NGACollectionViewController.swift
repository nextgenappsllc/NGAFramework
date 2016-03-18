//
//  NGACollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/9/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

class NGACollectionViewController: NGAViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionViewCellClass:AnyClass? {
        get {return UICollectionViewCell.self}
    }
    
    var collectionViewHeaderClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
    
    var collectionViewFooterClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
//    var portraitScrollDirection:UICollectionViewScrollDirection = UICollectionViewScrollDirection.Vertical
//    var landscapeScrollDirection:UICollectionViewScrollDirection = UICollectionViewScrollDirection.Horizontal
    
    
    lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        var temp = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        return temp
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionViewOnMainThread()
    }
    
    override func setup() {
        super.setup()
        automaticallyAdjustsScrollViewInsets = false
        contentView.backgroundColor = UIColor.whiteColor()
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.registerClass(self.collectionViewCellClass, forCellWithReuseIdentifier: "Cell")
        collectionView.registerClass(collectionViewHeaderClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.registerClass(collectionViewFooterClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func setFramesForSubviews() {
        super.setFramesForSubviews()
        setCollectionViewFrame()
        collectionView.reloadData()
//        collectionView.reloadInputViews()
    }
    
    func setCollectionViewFrame() {
        collectionView.frame = contentView.bounds
        collectionView.centerInView(contentView)
        contentView.addSubviewIfNeeded(collectionView)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifierForIndexPath(indexPath), forIndexPath: indexPath) ?? UICollectionViewCell()
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frameSize
    }
    
    
    func reloadCollectionViewOnMainThread(collectionView:UICollectionView? = nil) {
        let temp = collectionView ?? self.collectionView
        let mainBlock = {temp.reloadData()}
//        NGAExecute.performOnMainThread(mainBlock)
        dispatch_async(dispatch_get_main_queue(), mainBlock)
    }
    
    
    func cellReuseIdentifierForIndexPath(indexPath:NSIndexPath) -> String {
        return "Cell"
    }
    
    
}
































