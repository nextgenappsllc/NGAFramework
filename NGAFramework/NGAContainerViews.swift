//
//  NGAContainerViews.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 9/15/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGAContainerView: UIView {
    
    public var viewToCenter:UIView? {didSet{if viewToCenter != oldValue{ setFramesOnMainThread()}}}
    public var sizeRatio:CGFloat = 0.9  {didSet{if sizeRatio != oldValue{ setFramesOnMainThread()}}}
    public var circular:Bool = false {didSet{if circular != oldValue{ setFramesForSubviews()}}}
    public var containerXOffset:CGFloat = 0 {didSet{if containerXOffset > 1{containerXOffset = 1}else if containerXOffset < -1 {containerXOffset = -1}; if containerXOffset != oldValue {setFramesOnMainThread()}}}
    public var containerYOffset:CGFloat = 0 {didSet{if containerYOffset > 1{containerYOffset = 1}else if containerYOffset < -1 {containerYOffset = -1}; if containerYOffset != oldValue {setFramesOnMainThread()}}}
    public var squaredCenterView:Bool = false {didSet{if squaredCenterView != oldValue{ setFramesOnMainThread()}}}
    public override var frame:CGRect {didSet{if frame.size != oldValue.size{setFramesOnMainThread()}}}
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame:CGRectZero)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    
    public func setFramesOnMainThread() {
        NGAExecute.performOnMainThread(setFramesForSubviews)
    }
    
    public func setFramesForSubviews() {
        if circular {
            let side = shortSide > 0 ? shortSide : longSide
            if frameWidth != frameHeight {frameSize = CGSize.squareSizeWithLength(side)}
            viewToCenter?.frameSize = sizeForViewInCircularView()
            layer.cornerRadius = side / 2
        }
        else {viewToCenter?.setSizeFromView(self, withXRatio: sizeRatio, andYRatio: sizeRatio)}
        if squaredCenterView {if let s = viewToCenter?.shortSide { viewToCenter?.frameSize = CGSize.squareSizeWithLength(s)}}
        var xPadding:CGFloat = 0 ; var yPadding:CGFloat = 0
        if let size = viewToCenter?.frameSize {
            xPadding = (frameWidth - size.width) * containerXOffset
            yPadding = (frameHeight - size.height) * containerYOffset
        }
        viewToCenter?.placeViewInView(view: self, position: .AlignCenterX, andPadding: xPadding)
        viewToCenter?.placeViewInView(view: self, position: .AlignCenterY, andPadding: yPadding)
        addSubviewIfNeeded(viewToCenter)
        
    }
    
    public func sizeForViewInCircularView() -> CGSize {
        let s = sideSizeForViewInCircularView(self)
        return CGSizeMake(s, s)
    }
    
    public func sideSizeForViewInCircularView(v:UIView) -> CGFloat {
        let side = v.shortSide / sqrt(2) * sizeRatio
        return side
    }
    
}

class NGATapView: NGAContainerView {
    var callBack:VoidBlock?
    var callBackWithSender:((sender:AnyObject?) -> Void)?
    var tapRecognizer:UITapGestureRecognizer? {didSet{addTapGestureRecognizer(tapRecognizer, old: oldValue, toSelf: recognizeTapOnWholeContainer)}}
    var recognizeTapOnWholeContainer:Bool = true {didSet{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}}
    
    override var viewToCenter:UIView? {didSet{
        if let t = tapRecognizer {oldValue?.removeGestureRecognizer(t)}
        if !recognizeTapOnWholeContainer{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}
        }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("userTapped:"))
        addTapGestureRecognizer(tapRecognizer, old: nil, toSelf: recognizeTapOnWholeContainer)
//        self.addGestureRecognizer(tapRecognizer)
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame:CGRectZero)
    }
    
    func addTapGestureRecognizer(new:UITapGestureRecognizer?, old:UITapGestureRecognizer?, toSelf b:Bool) {
        if let o = old {viewToCenter?.removeGestureRecognizer(o); removeGestureRecognizer(o)}
        if let n = new {if b{addGestureRecognizer(n)}else {viewToCenter?.addGestureRecognizer(n); viewToCenter?.userInteractionEnabled = true}}
    }
    
    
    func userTapped(sender:AnyObject?) {
        //        print("tapped")
        callBack?()
        callBackWithSender?(sender: self)
    }
}



class NGATapLabelView: NGATapView {
    
    let label = UILabel()
    var text:String? {get{return label.text}set{label.text = newValue; setFramesForSubviews()}}
    var attributedText:NSAttributedString? {get{return label.attributedText}set{label.attributedText = newValue; setFramesForSubviews()}}
    var textColor:UIColor? {get{return label.textColor}set{label.textColor = newValue}}
    var font:UIFont? {get{return label.font}set{if label.font != newValue {label.font = newValue; setFramesForSubviews()}}}
    var textAlignment:NSTextAlignment {get{return label.textAlignment}set{label.textAlignment = newValue}}
    var labelRatio:CGFloat{get{return sizeRatio}set{sizeRatio = newValue}}
    var fitFontToLabel:Bool = true
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        viewToCenter = label
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame:CGRectZero)
    }
    
    
    
    override func setFramesForSubviews() {
        super.setFramesForSubviews()
        if fitFontToLabel && frameHeight > 0 && frameWidth > 0 {font = font?.fitFontToSize(label.frameSize, forString: label.text)}
    }
    
    
}



class NGATapImageView: NGATapView {
    let imageView = UIImageView()
    var image:UIImage? {get{return imageView.image}set{imageView.image = alwaysTemplate ? newValue?.imageWithRenderingMode(.AlwaysTemplate) : newValue}}
    var imageTintColor:UIColor? {get{return imageView.tintColor}set{imageView.tintColor = newValue}}
    var imageRatio:CGFloat {get{return sizeRatio}set{sizeRatio = newValue}}
    var imageContentMode:UIViewContentMode {get{return imageView.contentMode} set{imageView.contentMode = newValue}}
    var alwaysTemplate:Bool = true {didSet{if alwaysTemplate != oldValue {imageView.image = imageView.image}}}
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = UIColor.clearColor()
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleAspectFit
        imageTintColor = UIColor.blackColor()
        viewToCenter = imageView
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame:CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setFramesForSubviews()
    }
    
    
    
}





