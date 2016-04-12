//
//  NGACollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/9/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGACollectionViewController: NGAViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var collectionViewCellClass:AnyClass? {
        get {return NGACollectionViewCell.self}
    }
    
    public var collectionViewHeaderClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
    
    public var collectionViewFooterClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
    
    public lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        var temp = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        return temp
        }()
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionViewOnMainThread()
    }
    
    public override func setup() {
        super.setup()
        automaticallyAdjustsScrollViewInsets = false
        contentView.backgroundColor = UIColor.whiteColor()
        collectionView.backgroundColor = UIColor.whiteColor()
        registerClasses()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    public func registerClasses() {
        collectionView.registerClass(collectionViewCellClass, forCellWithReuseIdentifier: "Cell")
        collectionView.registerClass(collectionViewHeaderClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.registerClass(collectionViewFooterClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
    }
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        setCollectionViewFrame()
        collectionView.reloadData()
    }
    
    public func setCollectionViewFrame() {
        collectionView.frame = contentView.bounds
        collectionView.centerInView(contentView)
        contentView.addSubviewIfNeeded(collectionView)
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifierForIndexPath(indexPath), forIndexPath: indexPath) ?? NGACollectionViewCell()
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frameSize
    }
    
    
    public func reloadCollectionViewOnMainThread(collectionView:UICollectionView? = nil) {
        let temp = collectionView ?? self.collectionView
        NGAExecute.performOnMainThread(temp.reloadData)
//        dispatch_async(dispatch_get_main_queue(), mainBlock)
    }
    
    
    public func cellReuseIdentifierForIndexPath(indexPath:NSIndexPath) -> String {
        return "Cell"
    }
    
    
}
































