//
//  NGAParallaxCollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/10/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit



public class NGAParallaxCollectionViewController: NGACollectionViewController {
    
    public var autoChangeScrollView = true
    
    public override var collectionViewCellClass:AnyClass? {
        get {return NGAParallaxCollectionViewCell.self}
    }
    
    public override func setCollectionViewFrame() {
        super.setCollectionViewFrame()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = landscape ? .Horizontal : .Vertical
        for cell in collectionView.visibleCells() {setContentOffsetForCell(cell as? NGAParallaxCollectionViewCell)}
    }
    
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        if let scrollingCell = cell as? NGAParallaxCollectionViewCell {
            scrollingCell.uiDelegate = self
            if autoChangeScrollView {
                setContentOffsetForCell(scrollingCell)
            }
            
        }
        return cell
    }
    
    public override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var temp = CGSizeZero
        if landscape {temp.height = collectionView.shortSide * 0.95 ; temp.width = (collectionView.longSide / 2) * 0.95}
        else {temp.height = (collectionView.longSide / 2) * 0.95 ; temp.width = collectionView.shortSide * 0.95}
        return temp
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let amount = (contentView.longSide / 2) * 0.05
        let temp = landscape ? UIEdgeInsets(top: 0, left: amount, bottom: 0, right: amount) : UIEdgeInsets(top: amount, left: 0, bottom: amount, right: 0)
        return temp
    }
    
    
    public var thresholdRatio:CGFloat = 0.2
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == collectionView {
            let visibleCells = collectionView.visibleCells()
            for cell in visibleCells {
                setContentOffsetForCell(cell as? NGAParallaxCollectionViewCell)
            }
            let horizontalScroll = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == UICollectionViewScrollDirection.Horizontal
            let shouldRefresh = horizontalScroll ? scrollView.isLeftOfContentByMoreRatio(thresholdRatio) : scrollView.isAboveContentByMoreThanRatio(thresholdRatio)
            let shouldLoadMoreContent = horizontalScroll ? scrollView.isRightOfContentByMoreThanRatio(thresholdRatio) : scrollView.isBelowContentByMoreThanRatio(thresholdRatio)
            
            
            if shouldRefresh {
//                print("refresh")
                refreshContent()
            }
            if shouldLoadMoreContent {
//                print("load more")
                loadMoreContent()
            }
            
        }
    }
    
    public func refreshContent() {
        
    }
    
    public func loadMoreContent() {
        
    }
    
    
    public func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
        NGAExecute.performOnMainThread() {
            let contentView = self.contentView; let collectionView = self.collectionView ; let landscape = self.landscape
            guard contentView.longSide > 0, let c = cell else {return}
            let totalSize = contentView.longSide
            let cellFrame = collectionView.convertRect(c.frame, toView: contentView)
            let originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
            let ratio = originToTest / totalSize //; ratio = 1 - ratio
            let diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
            let offset = diff * ratio
            var newOffset = CGPointZero
            newOffset.x = landscape ? offset : 0
            newOffset.y = landscape ? 0 : offset
            c.scrollView.contentOffset = newOffset
            
        }
        
        
        
        
        
//        if let c = cell {
//            if collectionView.longSide == 0 {return}
//            let totalSize = contentView.longSide ; if totalSize == 0 {return}
//            let cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            let originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            let ratio = originToTest / totalSize //; ratio = 1 - ratio
//            if c.scrollView.frame != c.contentView.bounds { c.scrollView.frame = c.contentView.bounds}
//            if c.imageView.frameOrigin != CGPointZero {c.imageView.frameOrigin = CGPointZero}
//            if c.imageView.frameSize != cellFrame.size {c.imageView.frameSize = cellFrame.size}
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            
//            if let image = c.imageView.image {
//                let threshold = CGFloat(0.35)
//                if image.size.height < c.frameHeight * threshold || image.size.width < c.frameWidth * threshold {c.imageView.sizeToFit(); c.imageView.placeViewAccordingToView(view: c.scrollView, andPosition: .AlignCenterX)}
//            }
//            c.imageView.cornerRadius = (c.imageView.shortSide / c.shortSide) * c.cornerRadius
////            print("cell imageview corner radius = \(c.imageView.cornerRadius)")
//            
//            
//            let diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            let offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            c.label.frameSize = c.frameSize
//            c.label.sizeToFit()
//            
//            //            c.blurView.frameWidth = c.frameWidth * inverseFactor
//            //            c.blurView.frameHeight = c.label.frameHeight * inverseFactor
//            c.blurView.frameWidth = c.frameWidth * 1.2
//            c.blurView.frameHeight = c.label.frameHeight * 1.2
//            
//            //            c.blurView.layer.cornerRadius = c.blurView.shortSide / 2
//            
////            c.label.textColor = MCMVariables.secondaryTextColor
////            c.label.centerInView(c.blurView)
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.placeViewInView(view: c, position: NGARelativeViewPosition.AlignBottom, andPadding: 1)
//            c.blurView.placeViewInView(view: c, andPosition: NGARelativeViewPosition.AlignCenterX)
//        }
    }
    
    
}




public class NGAParallaxCollectionViewCell:NGACollectionViewCell {
    public lazy var scrollView:UIScrollView = {
        var temp = UIScrollView()
        temp.userInteractionEnabled = false
        temp.clipsToBounds = false
        return temp
        }()
    
    public lazy var imageView:UIImageView = {
        var temp = UIImageView()
//        temp.backgroundColor = UIColor.redColor()
        temp.contentMode = UIViewContentMode.ScaleAspectFill
        temp.clipsToBounds = false
        return temp
        }()
    
    public lazy var label:UILabel = {
        var temp = UILabel()
        temp.font = UIFont(name: "ArialRoundedMTBold", size: UIFont.systemFontSize())
        temp.textColor = UIColor.blackColor()
        temp.textAlignment = NSTextAlignment.Center
        temp.numberOfLines = 0
        return temp
        }()
    
    public lazy var blurView:UIVisualEffectView = {
        var temp = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
//        var temp = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 5.0
        return temp
        }()
//    var blurView = UIView()
    weak var uiDelegate:NGAParallaxCollectionViewController? {didSet {if oldValue != uiDelegate {setFramesForSubviewsOnMainThread()}}}
    var landscape:Bool {
        get {
            return uiDelegate?.landscape ?? false
        }
    }
    
    public var text:String? {
        didSet{label.text = text ; setFramesForSubviewsOnMainThread()}
    }
    public override func postInit() {
        super.postInit()
        clipsToBounds = true
        contentView.addSubviewIfNeeded(scrollView)
        scrollView.addSubviewIfNeeded(imageView)
        blurView.contentView.addSubviewsIfNeeded(label)
    }
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        if String.isNotEmpty(label.text) {contentView.addSubviewIfNeeded(self.blurView)} else {self.blurView.removeFromSuperview()}
        scrollView.frame = contentView.bounds
        imageView.frameOrigin = CGPointZero
        imageView.frameSize = frameSize
        if landscape {imageView.frameWidth *= 1.4} else {imageView.frameHeight *= 1.4}
        
        if let image = imageView.image {
            let threshold = CGFloat(0.35)
            if image.size.height < frameHeight * threshold || image.size.width < frameWidth * threshold {imageView.sizeToFit(); imageView.placeViewAccordingToView(view: scrollView, andPosition: .AlignCenterX)}
        }
        if shortSide > 0 {imageView.cornerRadius = (imageView.shortSide / shortSide) * cornerRadius}
        
        
        
        label.frameSize = frameSize
        label.sizeToFit()
        
        blurView.frameWidth = frameWidth * 1.2
        blurView.frameHeight = label.frameHeight * 1.2
        
        label.centerInView(blurView.contentView)
        blurView.placeViewInView(view: contentView, position: NGARelativeViewPosition.AlignBottom, andPadding: 1)
        blurView.placeViewInView(view: contentView, andPosition: NGARelativeViewPosition.AlignCenterX)

    }
    
    
}






















