//
//  NGAParallaxCollectionViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/10/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


//// might need to set frames of cells during the setting of subview frames

class NGAParallaxCollectionViewController: NGACollectionViewController {
    
    var autoChangeScrollView = true
    
    override var collectionViewCellClass:AnyClass? {
        get {return NGAParallaxCollectionViewCell.self}
    }
    
    override func setCollectionViewFrame() {
        super.setCollectionViewFrame()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = landscape ? .Horizontal : .Vertical
//        collectionView.reloadData()
        for cell in collectionView.visibleCells() {setContentOffsetForCell(cell as? NGAParallaxCollectionViewCell)}
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        if let scrollingCell = cell as? NGAParallaxCollectionViewCell {
            if autoChangeScrollView { setContentOffsetForCell(scrollingCell)}
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var temp = CGSizeZero
        if landscape {temp.height = collectionView.shortSide * 0.95 ; temp.width = (collectionView.longSide / 2) * 0.95}
        else {temp.height = (collectionView.longSide / 2) * 0.95 ; temp.width = collectionView.shortSide * 0.95}
        return temp
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let amount = (contentView.longSide / 2) * 0.05
        let temp = landscape ? UIEdgeInsets(top: 0, left: amount, bottom: 0, right: amount) : UIEdgeInsets(top: amount, left: 0, bottom: amount, right: 0)
        return temp
    }
    
    
    var thresholdRatio:CGFloat = 0.2
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
    
    func refreshContent() {
        
    }
    
    func loadMoreContent() {
        
    }
    
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            
//            
////            var factor = (ratio - 0.5) * 2
////            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
////            c.label.setSizeFromView(c, withXRatio: 1.0, andYRatio: 0.6)
////            c.blurView.alpha = abs(factor)
////            if landscape {
////                c.blurView.setSizeFromView(c, withXRatio: 1.0, andYRatio: 1.0)
////                c.label.centerInView(c.blurView.contentView)
////                c.blurView.frameOriginY = 0
////                c.blurView.frameOriginX = 0
//////                c.blurView.frameOriginX = factor <= 0 ? (c.blurView.frameWidth * factor) + c.frameWidth : -(c.blurView.frameWidth * (1 - factor))
////            }
////            else {
////                c.blurView.setSizeFromView(c.label, withXRatio: 1.1, andYRatio: 1.0)
////                c.label.centerInView(c.blurView.contentView)
////                c.blurView.top = factor > 0 ? 0 : c.frameHeight - c.blurView.frameHeight
////                c.blurView.placeViewInView(view: c.contentView, andPosition: NGARelativeViewPosition.AlignCenterX)
////            }
//            
//            
//            var factor = (ratio - 0.5) * 2
//            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
//            c.label.setSizeFromView(c, withXRatio: 1.0, andYRatio: 0.6)
////            c.blurView.alpha = abs(factor)
//            if landscape {
//                c.blurView.setSizeFromView(c, withXRatio: 1.0, andYRatio: factor * 1.1)
//                c.label.centerInView(c.blurView.contentView)
//                c.blurView.frameOriginY = 0
//                c.blurView.frameOriginX = factor <= 0 ? (c.blurView.frameWidth * factor) + c.frameWidth : -(c.blurView.frameWidth * (1 - factor))
//            }
//            else {
//                c.blurView.setSizeFromView(c.label, withXRatio: factor * 1.1, andYRatio: factor)
//                c.label.centerInView(c.blurView.contentView)
//                c.blurView.top = factor > 0 ? 0 : c.frameHeight - c.blurView.frameHeight
//                c.blurView.placeViewInView(view: c.contentView, andPosition: NGARelativeViewPosition.AlignCenterX)
//            }
//            
////            factor = factor > 0 ? 1 - factor : factor
////            var diameter = (c.blurView.shortSide + c.blurView.longSide) / 2 * (1 - abs(factor))
//            var diameter = c.blurView.shortSide * (1 - abs(factor))
//            c.blurView.layer.cornerRadius = diameter / 2
//            
//            
//        }
//    }
    
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            
//            
//            var factor = (ratio - 0.5) * 2
//            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
//            c.label.setSizeFromView(c, withXRatio: 1.0, andYRatio: 0.6)
//            c.blurView.setSizeFromView(c.label, withXRatio: factor * 1.1, andYRatio: factor)
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.top = factor > 0 ? 0 : c.frameHeight - c.blurView.frameHeight
//            c.blurView.placeViewInView(view: c.contentView, andPosition: NGARelativeViewPosition.AlignCenterX)
////            c.blurView.frameOriginX = 0
////            c.blurView.frameOriginY = factor <= 0 ? (c.blurView.frameHeight * factor) + c.frameHeight : -(c.blurView.frameHeight * (1 - factor))
//            
//        }
//    }
    
    
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize //; ratio = 1 - ratio
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            c.label.setSizeFromView(c, withXRatio: 1.0, andYRatio: 0.6)
//            c.blurView.frameSize = c.label.frameSize
//            c.label.centerInView(c.blurView.contentView)
//            var factor = (ratio - 0.5) * 2
//            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
//            c.blurView.frameOriginX = 0
//            c.blurView.frameOriginY = factor <= 0 ? (c.blurView.frameHeight * factor) + c.frameHeight : -(c.blurView.frameHeight * (1 - factor))
//            
//        }
//    }
    
    //// label size in middle
    
    //// TEST
    
    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
        if let c = cell {
            if collectionView.longSide == 0 {return}
            let totalSize = contentView.longSide ; if totalSize == 0 {return}
            let cellFrame = collectionView.convertRect(c.frame, toView: contentView)
            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
            let originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
            let ratio = originToTest / totalSize //; ratio = 1 - ratio
            if c.scrollView.frame != c.contentView.bounds { c.scrollView.frame = c.contentView.bounds}
            if c.imageView.frameOrigin != CGPointZero {c.imageView.frameOrigin = CGPointZero}
            if c.imageView.frameSize != cellFrame.size {c.imageView.frameSize = cellFrame.size}
            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
            
            if let image = c.imageView.image {
                let threshold = CGFloat(0.35)
                if image.size.height < c.frameHeight * threshold || image.size.width < c.frameWidth * threshold {c.imageView.sizeToFit(); c.imageView.placeViewAccordingToView(view: c.scrollView, andPosition: .AlignCenterX)}
            }
            c.imageView.cornerRadius = (c.imageView.shortSide / c.shortSide) * c.cornerRadius
//            print("cell imageview corner radius = \(c.imageView.cornerRadius)")
            
            
            let diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
            let offset = diff * ratio
            var newOffset = CGPointZero
            newOffset.x = landscape ? offset : 0
            newOffset.y = landscape ? 0 : offset
            c.scrollView.contentOffset = newOffset
            
            c.label.frameSize = c.frameSize
            c.label.sizeToFit()
            
            //            c.blurView.frameWidth = c.frameWidth * inverseFactor
            //            c.blurView.frameHeight = c.label.frameHeight * inverseFactor
            c.blurView.frameWidth = c.frameWidth * 1.2
            c.blurView.frameHeight = c.label.frameHeight * 1.2
            
            //            c.blurView.layer.cornerRadius = c.blurView.shortSide / 2
            
//            c.label.textColor = MCMVariables.secondaryTextColor
//            c.label.centerInView(c.blurView)
            c.label.centerInView(c.blurView.contentView)
            c.blurView.placeViewInView(view: c, position: NGARelativeViewPosition.AlignBottom, andPadding: 1)
            c.blurView.placeViewInView(view: c, andPosition: NGARelativeViewPosition.AlignCenterX)
        }
    }
    
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize //; ratio = 1 - ratio
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            var diameter = c.shortSide
//            var factor:CGFloat = abs(ratio - 0.5) * 2
//            
//            var collectionViewOffset = collectionView.contentOffset
//            var positionOffset = landscape ? collectionViewOffset.x : collectionViewOffset.y
//            var cellSize = landscape ? c.frameWidth : c.frameHeight
//            var cellPosition = landscape ? c.frameOriginX : c.frameOriginY
//            if positionOffset < cellSize && cellPosition > -cellSize && cellPosition < cellSize / 2 {factor -= 0.4}
//            //            println("collection view offset = \(positionOffset) ::: cell position = \(cellPosition)")
//            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
//            var inverseFactor = (1 - factor) * 1.3
//            c.label.frameSize = c.frameSize
//            c.label.sizeToFit()
//
//            c.blurView.frameWidth = c.frameWidth * inverseFactor
//            c.blurView.frameHeight = c.label.frameHeight * inverseFactor
////            c.blurView.frameWidth = c.frameWidth
////            c.blurView.frameHeight = c.label.frameHeight
//            
//            c.blurView.layer.cornerRadius = c.blurView.shortSide / 2
//            
//            
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.placeViewInView(view: c, position: NGARelativeViewPosition.AlignBottom, andPadding: 1)
//            c.blurView.placeViewInView(view: c, andPosition: NGARelativeViewPosition.AlignCenterX)
//        }
//    }
    
    
    
    
    
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize //; ratio = 1 - ratio
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            var diameter = c.shortSide
//            var factor:CGFloat = abs(ratio - 0.5) * 2
//            
//            var collectionViewOffset = collectionView.contentOffset
//            var positionOffset = landscape ? collectionViewOffset.x : collectionViewOffset.y
//            var cellSize = landscape ? c.frameWidth : c.frameHeight
//            var cellPosition = landscape ? c.frameOriginX : c.frameOriginY
//            if positionOffset < cellSize && cellPosition > -cellSize && cellPosition < cellSize / 2 {factor -= 0.4 ; println("first cell")}
////            println("collection view offset = \(positionOffset) ::: cell position = \(cellPosition)")
//            if factor > 1 {factor = 1} else if factor < -1 {factor = -1}
//            var inverseFactor = (1 - factor) * 1.3
//            c.label.frameSize = c.frameSize
//            c.label.sizeToFit()
////            c.blurView.setSizeFromView(c.label, withXRatio: inverseFactor, andYRatio: inverseFactor)
//            //            c.blurView.frameSize = CGSizeMake(diameter, diameter)
//            c.blurView.frameWidth = c.frameWidth * inverseFactor
//            c.blurView.frameHeight = c.label.frameHeight * inverseFactor
//            c.blurView.layer.cornerRadius = c.blurView.shortSide / 2
//            
//            //            var squareLength = sqrt(pow(c.shortSide, 2) / 2)
//            
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.placeViewInView(view: c, position: NGARelativeViewPosition.AlignBottom, andPadding: 1)
//            c.blurView.placeViewInView(view: c, andPosition: NGARelativeViewPosition.AlignCenterX)
//        }
//    }
    
    //// full big in middle
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
//            //            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize //; ratio = 1 - ratio
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            var diameter = c.shortSide
//            var factor:CGFloat = 1
//            factor = abs(ratio - 0.5) * 2
//            var inverseFactor = (1 - factor) * 1.1
//            c.blurView.setSizeFromView(c, withXRatio: inverseFactor, andYRatio: inverseFactor)
////            c.blurView.frameSize = CGSizeMake(diameter, diameter)
//            c.blurView.layer.cornerRadius = c.blurView.shortSide / 2 * factor
//            
////            var squareLength = sqrt(pow(c.shortSide, 2) / 2)
//            c.label.frameSize = c.frameSize
//          //  c.label.sizeToFit()
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.centerInView(c.contentView)
//        }
//    }

    
    
    ///// bubble
    
//    func setContentOffsetForCell(cell:NGAParallaxCollectionViewCell?) {
//        if let c = cell {
//            var totalSize = contentView.longSide ; if totalSize == 0 {return}
//            var cellFrame = collectionView.convertRect(c.frame, toView: contentView)
////            var originToTest = landscape ? cellFrame.origin.x: cellFrame.origin.y
//            var originToTest = landscape ? cellFrame.origin.x + cellFrame.size.width / 2: cellFrame.origin.y + cellFrame.size.height / 2
//            var ratio = originToTest / totalSize //; ratio = 1 - ratio
//            c.scrollView.frame = c.contentView.bounds
//            c.imageView.frameOrigin = CGPointZero
//            c.imageView.frameSize = cellFrame.size
//            if landscape {c.imageView.frameWidth *= 1.4} else {c.imageView.frameHeight *= 1.4}
//            var diff = landscape ? c.imageView.frameWidth - c.scrollView.frameWidth : c.imageView.frameHeight - c.scrollView.frameHeight
//            var offset = diff * ratio
//            var newOffset = CGPointZero
//            newOffset.x = landscape ? offset : 0
//            newOffset.y = landscape ? 0 : offset
//            c.scrollView.contentOffset = newOffset
//            
//            var diameter = c.shortSide
//            var factor:CGFloat = 1
//            factor = abs(ratio - 0.5) * 2
//            diameter *= (1 - factor)
//            
//            c.blurView.frameSize = CGSizeMake(diameter, diameter)
//            c.blurView.layer.cornerRadius = diameter / 2
//            
//            var squareLength = sqrt(pow(c.shortSide, 2) / 2)
//            c.label.frameSize = CGSizeMake(squareLength, squareLength)
//            
//            c.label.centerInView(c.blurView.contentView)
//            c.blurView.centerInView(c.contentView)
//        }
//    }
    
}




class NGAParallaxCollectionViewCell:UICollectionViewCell {
    lazy var scrollView:UIScrollView = {
        var temp = UIScrollView()
        temp.userInteractionEnabled = false
        temp.clipsToBounds = false
        return temp
        }()
    
    lazy var imageView:UIImageView = {
        var temp = UIImageView()
//        temp.backgroundColor = UIColor.redColor()
        temp.contentMode = UIViewContentMode.ScaleAspectFill
        temp.clipsToBounds = false
        return temp
        }()
    
    lazy var label:UILabel = {
        var temp = UILabel()
        temp.font = UIFont(name: "ArialRoundedMTBold", size: UIFont.systemFontSize())
        temp.textColor = UIColor.blackColor()
        temp.textAlignment = NSTextAlignment.Center
        temp.numberOfLines = 0
        return temp
        }()
    
    lazy var blurView:UIVisualEffectView = {
        var temp = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
//        var temp = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        temp.clipsToBounds = true
        temp.layer.cornerRadius = 5.0
        return temp
        }()
//    var blurView = UIView()
    
    var text:String? {
        didSet{label.text = text /*; setFramesForSubviews()*/}
    }
    
    override var frame:CGRect {
        get {return super.frame}
        set {super.frame = newValue}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setFramesForSubviews()
    }
    
    func setFramesForSubviews() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.clipsToBounds = true
            self.contentView.addSubviewIfNeeded(self.scrollView)
            self.scrollView.addSubviewIfNeeded(self.imageView)
            self.blurView.addSubviewsIfNeeded(self.label)
            //        blurView.backgroundColor = MCMVariables.secondaryViewColor
            self.blurView.contentView.addSubviewIfNeeded(self.label)
            if self.label.text != nil {self.contentView.addSubviewIfNeeded(self.blurView)} else {self.blurView.removeFromSuperview()}
        }
        
        
        
    }
    
    
}






















