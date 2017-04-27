//
//  NGAView.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/28/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGAView: UIView {
    open override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    open func setFramesForSubviews() {}
    open func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainQueue(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    open func postInit() {}
    open var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    

    
}

open class NGACollectionViewCell: UICollectionViewCell {
    open override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    open func setFramesForSubviews() {}
    open func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainQueue(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    open func postInit() {}
    open override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    open var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    
}

open class NGACollectionReusableView: UICollectionReusableView {
    open override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    open func setFramesForSubviews() {}
    open func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainQueue(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    open func postInit() {}
    open override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    open var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
}

open class NGATableViewCell: UITableViewCell {
    open override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    open func setFramesForSubviews() {}
    open func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainQueue(setFramesForSubviews)}
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    open func postInit() {}
    open override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    open var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
}



open class NGAScrollView: UIScrollView {
    open override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    open func setFramesForSubviews() {}
    open func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainQueue(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    open func postInit() {}
    open var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    
}










