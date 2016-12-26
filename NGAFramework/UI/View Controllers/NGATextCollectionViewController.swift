//
//  NGATextCollectionViewController.swift
//  MCM
//
//  Created by Jose Castellanos on 2/19/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit




open class NGATextCollectionViewController: NGACollectionViewController {
    
    
    
    
    open override var collectionViewCellClass:AnyClass? {
        get {return LabelCollectionViewCell.self}
    }
    
    open override var collectionViewHeaderClass:AnyClass? {
        get {return LabelCollectionHeaderView.self}
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        cellRightTextColor = UIColor.black
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionArray.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowsForSection(section).count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        let width = contentView.frameWidth * cellXRatio
        label.frameWidth = width * cellLabelXRatio
        label.attributedText = attributedTextForIndexPath(indexPath)
        label.sizeToFit()
        return CGSize(width: width, height: label.frameHeight)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let text = textForHeaderForSection(section)
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        let width = contentView.frameWidth * headerXRatio
        label.frameWidth = width * headerLabelXRatio
        label.font = headerFont
        label.sizeToFit()
        return CGSize(width: width, height: label.frameHeight)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let c = cell as? LabelCollectionViewCell {
            c.label.textAlignment = .left
//            c.label.text = textForIndexPath(indexPath)
//            c.label.font = cellFont
            c.label.attributedText = attributedTextForIndexPath(indexPath)
            c.contentView.backgroundColor = cellBackgroundColor
//            c.label.textColor = cellTextColor
            c.xRatio = cellLabelXRatio
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let temp = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        if let v = temp as? LabelCollectionHeaderView {
            v.label.text = textForHeaderForSection((indexPath as NSIndexPath).section)
            v.backgroundColor = headerBackgroundColor
            v.label.textColor = headerTextColor
            v.label.font = headerFont
            v.xRatio = headerLabelXRatio
        }
        return temp
    }
    
    
    
    //MARK: Text Source
    
    open var cellFont:UIFont? = UIFont(name: NGAFontNames.HelveticaNeueLight, size: 16.0) {didSet{reloadCollectionViewOnMainThread()}}
    open var cellLeftFont:UIFont? {didSet{reloadCollectionViewOnMainThread()}}
    open var cellRightFont:UIFont? {didSet{reloadCollectionViewOnMainThread()}}
    open var headerFont:UIFont? = UIFont(name: NGAFontNames.HelveticaNeue, size: 18.0) {didSet{reloadCollectionViewOnMainThread()}}
    
    open var cellXRatio:CGFloat = 1 {didSet{reloadCollectionViewOnMainThread()}}
    open var headerXRatio:CGFloat = 1 {didSet{reloadCollectionViewOnMainThread()}}
    open var cellLabelXRatio:CGFloat = 0.95 {didSet{reloadCollectionViewOnMainThread()}}
    open var headerLabelXRatio:CGFloat = 0.98 {didSet{reloadCollectionViewOnMainThread()}}
    
    open var headerBackgroundColor:UIColor = UIColor.darkGray {didSet{reloadCollectionViewOnMainThread()}}
    open var headerTextColor:UIColor = UIColor.white {didSet{reloadCollectionViewOnMainThread()}}
    open var cellBackgroundColor:UIColor = UIColor.white {didSet{reloadCollectionViewOnMainThread()}}
    open var cellTextColor:UIColor = UIColor.darkGray {didSet{reloadCollectionViewOnMainThread()}}
    open var cellLeftTextColor:UIColor? {didSet{reloadCollectionViewOnMainThread()}}
    open var cellRightTextColor:UIColor? {didSet{reloadCollectionViewOnMainThread()}}
    
    
    open func setTextArray(_ a:SwiftArray?) {
        if let textArray = a {
            sectionArray = textArray.collect(initialValue: []) { (t:[[AnyHashable: Any]], element:Any) -> [[AnyHashable: Any]] in
                var total = t
                if let dict = element as? [AnyHashable: Any] {
                    var sectionDictionary = total.last ?? [:]
                    var rows = sectionDictionary["rows"] as? SwiftArray ?? []
                    rows.append(dict as Any)
                    sectionDictionary["rows"] = rows
                    let _=total.safeSet(total.count - 1, toElement: sectionDictionary)
                } else {
                    var sectionDictionary:[AnyHashable: Any] = [:]
                    sectionDictionary["header"] = element
                    total.append(sectionDictionary)
                }
//                print(element)
                return total
            }
        }
        
    }
    
    open func attributedTextForIndexPath(_ indexPath:IndexPath) -> NSAttributedString? {
        if let dict = rowsForSection((indexPath as NSIndexPath).section).itemAtIndex((indexPath as NSIndexPath).row) as? [AnyHashable: Any] {
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
    
    
    open func textForHeaderForSection(_ section:Int) -> String? {
        if let temp = headerObjectForSection(section) {return "\(temp)"}
        return nil
    }
    
    open func rowsForSection(_ section:Int) -> SwiftArray {
        return sectionArray.itemAtIndex(section)?.arrayForKey("rows") ?? []
    }
    open func headerObjectForSection(_ section:Int) -> Any? {
        return sectionArray.itemAtIndex(section)?.valueForKey("header")
    }
    
    
    open var sectionArray:[[AnyHashable: Any]] = [[:]] {
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
    func setFramesOnMainThread() {DispatchQueue.main.async(execute: setFrames)}
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
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
    func setFramesOnMainThread() {DispatchQueue.main.async(execute: setFrames)}
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
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





