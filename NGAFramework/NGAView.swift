//
//  NGAView.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/28/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGAView: UIView {
    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    public func setFramesForSubviews() {}
    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    public func postInit() {}
    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    
//    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setNeedsLayout()}}}
//    public func setFramesForSubviews() {}
//    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        postInit()
//    }
//    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
//    public func postInit() {}
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        setFramesForSubviews()
//    }
//    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setNeedsLayout()}}}
    
}

public class NGACollectionViewCell: UICollectionViewCell {
    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    public func setFramesForSubviews() {}
    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    public func postInit() {}
    public override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    
//    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setNeedsLayout()}}}
//    public func setFramesForSubviews() {}
//    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        postInit()
//    }
//    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
//    public func postInit() {}
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        setFramesForSubviews()
//    }
//    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setNeedsLayout()}}}
}

public class NGACollectionReusableView: UICollectionReusableView {
    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    public func setFramesForSubviews() {}
    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    public func postInit() {}
    public override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
}

public class NGATableViewCell: UITableViewCell {
    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    public func setFramesForSubviews() {}
    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    public func postInit() {}
    public override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
}



public class NGAScrollView: UIScrollView {
    public override var frame: CGRect {didSet{if autoUpdateFrames && oldValue.size != frame.size {setFramesForSubviewsOnMainThread()}}}
    public func setFramesForSubviews() {}
    public func setFramesForSubviewsOnMainThread() {NGAExecute.performOnMainThread(setFramesForSubviews)}
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    public convenience required init?(coder aDecoder: NSCoder) {self.init()}
    public func postInit() {}
    public var autoUpdateFrames:Bool = true {didSet{if autoUpdateFrames && !oldValue {setFramesForSubviewsOnMainThread()}}}
    
}










