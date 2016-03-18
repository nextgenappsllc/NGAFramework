//
//  NGATextCollectionViewController.swift
//  MCM
//
//  Created by Jose Castellanos on 2/19/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit




class NGATextCollectionViewController: NGACollectionViewController {
    
    
    
    
    override var collectionViewCellClass:AnyClass? {
        get {return LabelCollectionViewCell.self}
    }
    
    override var collectionViewHeaderClass:AnyClass? {
        get {return LabelCollectionHeaderView.self}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        cellRightTextColor = UIColor.blackColor()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sectionArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowsForSection(section).count
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        let width = contentView.frameWidth * cellXRatio
        label.frameWidth = width * cellLabelXRatio
        label.attributedText = attributedTextForIndexPath(indexPath)
        label.sizeToFit()
        return CGSizeMake(width, label.frameHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let text = textForHeaderForSection(section)
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        let width = contentView.frameWidth * headerXRatio
        label.frameWidth = width * headerLabelXRatio
        label.font = headerFont
        label.sizeToFit()
        return CGSizeMake(width, label.frameHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        if let c = cell as? LabelCollectionViewCell {
            c.label.textAlignment = .Left
//            c.label.text = textForIndexPath(indexPath)
//            c.label.font = cellFont
            c.label.attributedText = attributedTextForIndexPath(indexPath)
            c.contentView.backgroundColor = cellBackgroundColor
//            c.label.textColor = cellTextColor
            c.xRatio = cellLabelXRatio
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let temp = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
        if let v = temp as? LabelCollectionHeaderView {
            v.label.text = textForHeaderForSection(indexPath.section)
            v.backgroundColor = headerBackgroundColor
            v.label.textColor = headerTextColor
            v.label.font = headerFont
            v.xRatio = headerLabelXRatio
        }
        return temp
    }
    
    
    
    //MARK: Text Source
    
    var cellFont:UIFont? = UIFont(name: NGAFontNames.HelveticaNeueLight, size: 16.0) {didSet{reloadCollectionViewOnMainThread()}}
    var cellLeftFont:UIFont? {didSet{reloadCollectionViewOnMainThread()}}
    var cellRightFont:UIFont? {didSet{reloadCollectionViewOnMainThread()}}
    var headerFont:UIFont? = UIFont(name: NGAFontNames.HelveticaNeue, size: 18.0) {didSet{reloadCollectionViewOnMainThread()}}
    
    var cellXRatio:CGFloat = 1 {didSet{reloadCollectionViewOnMainThread()}}
    var headerXRatio:CGFloat = 1 {didSet{reloadCollectionViewOnMainThread()}}
    var cellLabelXRatio:CGFloat = 0.95 {didSet{reloadCollectionViewOnMainThread()}}
    var headerLabelXRatio:CGFloat = 0.98 {didSet{reloadCollectionViewOnMainThread()}}
    
    var headerBackgroundColor:UIColor = UIColor.darkGrayColor() {didSet{reloadCollectionViewOnMainThread()}}
    var headerTextColor:UIColor = UIColor.whiteColor() {didSet{reloadCollectionViewOnMainThread()}}
    var cellBackgroundColor:UIColor = UIColor.whiteColor() {didSet{reloadCollectionViewOnMainThread()}}
    var cellTextColor:UIColor = UIColor.darkGrayColor() {didSet{reloadCollectionViewOnMainThread()}}
    var cellLeftTextColor:UIColor? {didSet{reloadCollectionViewOnMainThread()}}
    var cellRightTextColor:UIColor? {didSet{reloadCollectionViewOnMainThread()}}
    
    
    func setTextArray(a:[AnyObject]?) {
        if let textArray = a {
            sectionArray = textArray.collect(initialValue: []) { (var total:[[NSObject:AnyObject]], element:AnyObject) -> [[NSObject:AnyObject]] in
                if let dict = element as? [NSObject:AnyObject] {
                    var sectionDictionary = total.last ?? [:]
                    var rows = sectionDictionary["rows"] as? [AnyObject] ?? []
                    rows.append(dict)
                    sectionDictionary["rows"] = rows
                    total.safeSet(total.count - 1, toElement: sectionDictionary)
                } else {
                    var sectionDictionary:[NSObject:AnyObject] = [:]
                    sectionDictionary["header"] = element
                    total.append(sectionDictionary)
                }
                print(element)
                return total
            }
        }
        
    }
    
    func attributedTextForIndexPath(indexPath:NSIndexPath) -> NSAttributedString? {
        if let dict = rowsForSection(indexPath.section).itemAtIndex(indexPath.row) as? [NSObject:AnyObject] {
            let key = dict.keys.first; let value = dict.values.first
            var temp = NSAttributedString()
            if let k = key {
                let keyString = "\(k)"
                if !keyString.isEmpty() {
                    temp = temp.append(keyString.toAttributedString(font: cellLeftFont ?? cellFont, color: cellLeftTextColor ?? cellTextColor))
                    if value != nil && !"\(value!)".isEmpty() {temp = temp.append(": ".toAttributedString(font: cellLeftFont ?? cellFont, color: cellLeftTextColor ?? cellTextColor))}
                }
                
            }
            if let v = value {
                let valueString = "\(v)"
                if !valueString.isEmpty() {
                   temp = temp.append("\(v)".toAttributedString(font: cellRightFont ?? cellFont, color: cellRightTextColor ?? cellTextColor))
                }
                
            }
            return temp
            
        }
        
        return nil
    }
    
    
    func textForHeaderForSection(section:Int) -> String? {
        if let temp = headerObjectForSection(section) {return "\(temp)"}
        return nil
    }
    
    func rowsForSection(section:Int) -> [AnyObject] {
        return sectionArray.itemAtIndex(section)?.arrayForKey("rows") ?? []
    }
    func headerObjectForSection(section:Int) -> AnyObject? {
        return sectionArray.itemAtIndex(section)?.valueForKey("header")
    }
    
    
    var sectionArray:[[NSObject:AnyObject]] = [[:]] {
        didSet{
            reloadCollectionViewOnMainThread()
            print(sectionArray)
        }
    }
    
    
    
    
    
}



private class LabelCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    var xRatio:CGFloat = 1.0 {didSet{setFramesOnMainThread()}}
    override var frame:CGRect {didSet{if oldValue.size != frame.size {setFramesOnMainThread()}}}
    override func layoutSubviews() {super.layoutSubviews(); setFramesOnMainThread()}
    func setFramesOnMainThread() {dispatch_async(dispatch_get_main_queue(), setFrames)}
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setup() {
        //        label.textAlignment = .Left
//        label.fitFontToLabel = false
    }
    func setFrames() {
        //        label.frame = contentView.bounds
        //        contentView.addSubviewsIfNeeded(label)
        label.numberOfLines = 0
        label.setSizeFromView(contentView, withXRatio: xRatio, andYRatio: 1.0)
        label.centerInView(contentView)
        contentView.addSubviewsIfNeeded(label)
    }
    
    
}


private class LabelCollectionHeaderView: UICollectionReusableView {
    let label = UILabel()
    var xRatio:CGFloat = 1.0 {didSet{setFramesOnMainThread()}}
    override var frame:CGRect {didSet{if oldValue.size != frame.size {setFramesOnMainThread()}}}
    override func layoutSubviews() {super.layoutSubviews(); setFramesOnMainThread()}
    func setFramesOnMainThread() {dispatch_async(dispatch_get_main_queue(), setFrames)}
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setup() {
        //        label.textAlignment = .Left
        //        label.fitFontToLabel = false
    }
    func setFrames() {
        //        label.frame = contentView.bounds
        //        contentView.addSubviewsIfNeeded(label)
        label.numberOfLines = 0
        label.setSizeFromView(self, withXRatio: xRatio, andYRatio: 1.0)
        label.centerInView(self)
        self.addSubviewsIfNeeded(label)
    }
    
    
}





