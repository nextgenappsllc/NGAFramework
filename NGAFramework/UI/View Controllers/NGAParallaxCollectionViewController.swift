//
//  NGAParallaxCollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/10/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit



open class NGAParallaxCollectionViewController: NGACollectionViewController {
    
    open var autoChangeScrollView = true
    
    open override var collectionViewCellClass:AnyClass? {
        get {return NGAParallaxCollectionViewCell.self}
    }
    
    open override func setCollectionViewFrame() {
        super.setCollectionViewFrame()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = landscape ? .horizontal : .vertical
        for cell in collectionView.visibleCells {setContentOffsetForCell(cell as? NGAParallaxCollectionViewCell)}
    }
    
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let scrollingCell = cell as? NGAParallaxCollectionViewCell {
            scrollingCell.uiDelegate = self
            if autoChangeScrollView {
                setContentOffsetForCell(scrollingCell)
            }
            
        }
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var temp = CGSize.zero
        if landscape {temp.height = collectionView.shortSide * 0.95 ; temp.width = (collectionView.longSide / 2) * 0.95}
        else {temp.height = (collectionView.longSide / 2) * 0.95 ; temp.width = collectionView.shortSide * 0.95}
        return temp
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let amount = (contentView.longSide / 2) * 0.05
        let temp = landscape ? UIEdgeInsets(top: 0, left: amount, bottom: 0, right: amount) : UIEdgeInsets(top: amount, left: 0, bottom: amount, right: 0)
        return temp
    }
    
    
    open var thresholdRatio:CGFloat = 0.2
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let visibleCells = collectionView.visibleCells
            for cell in visibleCells {
                setContentOffsetForCell(cell as? NGAParallaxCollectionViewCell)
            }
            let horizontalScroll = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == UICollectionViewScrollDirection.horizontal
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
    
    open func refreshContent() {
        
    }
    
    open func loadMoreContent() {
        
    }
    
    
    open func setContentOffsetForCell(_ cell:NGAParallaxCollectionViewCell?) {
        NGAExecute.performOnMainQueue() {
            let contentView = self.contentView; let collectionView = self.collectionView ; let landscape = self.landscape
            guard contentView.longSide > 0, let c = cell else {return}
            let totalSize = contentView.longSide
            let cellFrame = collectionView.convert(c.frame, to: contentView)
            let originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
            let ratio = originToTest / totalSize //; ratio = 1 - ratio
            let diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
            let offset = diff * ratio
            var newOffset = CGPoint.zero
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




open class NGAParallaxCollectionViewCell:NGACollectionViewCell {
    open lazy var scrollView:UIScrollView = {
        var temp = UIScrollView()
        temp.isUserInteractionEnabled = false
        temp.clipsToBounds = false
        return temp
        }()
    
    open lazy var imageView:UIImageView = {
        var temp = UIImageView()
//        temp.backgroundColor = UIColor.redColor()
        temp.contentMode = UIViewContentMode.scaleAspectFill
        temp.clipsToBounds = false
        return temp
        }()
    
    open lazy var label:UILabel = {
        var temp = UILabel()
        temp.font = UIFont(name: "ArialRoundedMTBold", size: UIFont.systemFontSize)
        temp.textColor = UIColor.black
        temp.textAlignment = NSTextAlignment.center
        temp.numberOfLines = 0
        return temp
        }()
    
    open lazy var blurView:UIVisualEffectView = {
        var temp = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
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
    
    open var text:String? {
        didSet{label.text = text ; setFramesForSubviewsOnMainThread()}
    }
    open override func postInit() {
        super.postInit()
        clipsToBounds = true
        contentView.addSubviewIfNeeded(scrollView)
        scrollView.addSubviewIfNeeded(imageView)
        blurView.contentView.addSubviewsIfNeeded(label)
    }
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        if String.isNotEmpty(label.text) {contentView.addSubviewIfNeeded(self.blurView)} else {self.blurView.removeFromSuperview()}
        scrollView.frame = contentView.bounds
        imageView.frameOrigin = CGPoint.zero
        imageView.frameSize = frameSize
        if landscape {imageView.frameWidth *= 1.4} else {imageView.frameHeight *= 1.4}
        
        if let image = imageView.image {
            let threshold = CGFloat(0.35)
            if image.size.height < frameHeight * threshold || image.size.width < frameWidth * threshold {imageView.sizeToFit(); imageView.placeViewAccordingToView(view: scrollView, andPosition: .alignCenterX)}
        }
        if shortSide > 0 {imageView.cornerRadius = (imageView.shortSide / shortSide) * cornerRadius}
        
        
        
        label.frameSize = frameSize
        label.sizeToFit()
        
        blurView.frameWidth = frameWidth * 1.2
        blurView.frameHeight = label.frameHeight * 1.2
        
        label.centerInView(blurView.contentView)
        blurView.placeViewInView(view: contentView, position: NGARelativeViewPosition.alignBottom, andPadding: 1)
        blurView.placeViewInView(view: contentView, andPosition: NGARelativeViewPosition.alignCenterX)

    }
    
    
}






















