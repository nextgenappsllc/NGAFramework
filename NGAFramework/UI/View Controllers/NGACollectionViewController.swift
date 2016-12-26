//
//  NGACollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/9/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGACollectionViewController: NGAViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open var collectionViewCellClass:AnyClass? {
        get {return NGACollectionViewCell.self}
    }
    
    open var collectionViewHeaderClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
    
    open var collectionViewFooterClass:AnyClass? {
        get {return UICollectionReusableView.self}
    }
    
    open lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        var temp = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        return temp
        }()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionViewOnMainThread()
    }
    
    open override func setup() {
        super.setup()
        automaticallyAdjustsScrollViewInsets = false
        contentView.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        registerClasses()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    open func registerClasses() {
        collectionView.register(collectionViewCellClass, forCellWithReuseIdentifier: "Cell")
        collectionView.register(collectionViewHeaderClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(collectionViewFooterClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        setCollectionViewFrame()
        collectionView.reloadData()
    }
    
    open func setCollectionViewFrame() {
        collectionView.frame = contentView.bounds
        collectionView.centerInView(contentView)
        contentView.addSubviewIfNeeded(collectionView)
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifierForIndexPath(indexPath), for: indexPath) 
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frameSize
    }
    
    
    open func reloadCollectionViewOnMainThread(_ collectionView:UICollectionView? = nil) {
        let temp = collectionView ?? self.collectionView
        NGAExecute.performOnMainThread(temp.reloadData)
//        dispatch_async(dispatch_get_main_queue(), mainBlock)
    }
    
    
    open func cellReuseIdentifierForIndexPath(_ indexPath:IndexPath) -> String {
        return "Cell"
    }
    
    
}
































