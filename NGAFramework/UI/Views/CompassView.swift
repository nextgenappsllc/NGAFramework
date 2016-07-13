//
//  CompassView.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/29/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public class CompassView: NGAView {
    public let mask = UIView()
    public let nLabel = UILabel()
    public let eLabel = UILabel()
    public let sLabel = UILabel()
    public let wLabel = UILabel()
    public let pointer = UIView()
    public let degreesLabel = UILabel()
    public let titleLabel = UILabel()
    public var title:String? {
        didSet {
            setFramesForSubviews()
        }
    }
    
    public var errorColor:UIColor? = UIColor.redColor() {
        didSet {
            if errorColor != oldValue {
                if error { degreesLabel.textColor = errorColor }
            }
        }
    }
    public var pointerColor:UIColor? = UIColor.blueColor() {
        didSet {
            pointer.backgroundColor = pointerColor
        }
    }
    public var degreesColor:UIColor? = UIColor.darkGrayColor() {
        didSet {
            if degreesColor != oldValue {
                if !error { degreesLabel.textColor = degreesColor }
            }
        }
    }
    public var degreesLabelColor:UIColor? {get{return error ? errorColor : degreesColor}}
    public var coordinateColor:UIColor? = UIColor.blackColor() {
        didSet {
            if coordinateColor != oldValue {
                for label in coordinateLabels {
                    label.textColor = coordinateColor
                }
            }
        }
    }
    
    public var negativeValueError:Bool = true {didSet{if oldValue != negativeValueError {setMaskFrame()}}}
    public var error:Bool {get{return negativeValueError ? radians < 0 : false}}
    
    public var constrainDegreesTo360:Bool = true {didSet{if constrainDegreesTo360 != oldValue {setMaskFrame()}}}
    
    public var coordinateLabels:[UILabel] {get{ return [nLabel, eLabel, sLabel, wLabel]}}
    public var font:UIFont? = UIFont(name: NGAFontNames.HelveticaNeueUltraLight, size: 12.0) {
        didSet {
            if font != oldValue {setFramesForSubviews()}
        }
    }
    
    public var degrees:CGFloat {
        get {
            var d = (radians.toDouble() * 180 / M_PI).toCGFloat()
            if !constrainDegreesTo360 {return d}
            while d > 360 {d -= 360}
            return d
        }
        set {radians = (newValue.toDouble() * M_PI / 180).toCGFloat()}
    }
    public var radians:CGFloat = 0 {
        didSet{
            if oldValue != radians {
                setMaskFrame()
            }
        }
    }
    
    
    public override func postInit() {
        super.postInit()
        nLabel.text = "N"
        eLabel.text = "E"
        sLabel.text = "S"
        wLabel.text = "W"
        addSubview(mask)
        for label in coordinateLabels {
            addSubview(label)
            label.textAlignment = .Center
            label.textColor = coordinateColor
        }
        degreesLabel.textAlignment = .Center
        degreesLabel.textColor = degreesLabelColor
        titleLabel.textColor = degreesColor
        addSubview(degreesLabel)
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        mask.addSubview(pointer)
        mask.backgroundColor = UIColor.clearColor()
        pointer.backgroundColor = pointerColor
    }
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        toCircle()
        let short = shortSide
        var s = short / 4
        for label in coordinateLabels {
            label.font = font
            label.frameSize = CGSizeMake(s, s)
            label.fitTextToSize()
        }
        for label in [eLabel, wLabel] {
            label.placeViewInView(view: self, andPosition: .AlignCenterY)
        }
        for label in [nLabel, sLabel] {
            label.placeViewInView(view: self, andPosition: .AlignCenterX)
        }
        nLabel.placeViewInView(view: self, position: .AlignTop, andPadding: 0)
        eLabel.placeViewInView(view: self, position: .AlignRight, andPadding: 0)
        sLabel.placeViewInView(view: self, position: .AlignBottom, andPadding: 0)
        wLabel.placeViewInView(view: self, position: .AlignLeft, andPadding: 0)
        
        
        s *= 2
//        degreesLabel.fitViewInCiricleWithRadius(s)
        degreesLabel.frameSize = CGSizeMake(s, s / 2)
        degreesLabel.font = font
        let text = degreesLabel.text
        degreesLabel.text = "999..99°"
        degreesLabel.fitTextToSize()
        degreesLabel.text = text
        
        
        
        titleLabel.frameSize = CGSizeMake(s, s / 2)
        titleLabel.numberOfLines = 0
//        titleLabel.fitViewInCiricleWithRadius(s)
        titleLabel.font = font
        titleLabel.text = title
        titleLabel.fitTextToSize()
        titleLabel.sizeToFit()
        titleLabel.placeViewInView(view: self, andPosition: .AlignCenterX)
        titleLabel.placeViewInView(view: self, position: .AlignCenterY, andPadding: -titleLabel.frameHeight / 2)
        
        
        setMaskFrame()
        
    }
    
    public func setMaskFrame() {
        mask.transform = CGAffineTransformMakeRotation(0)
        let short = shortSide
        mask.frameSize = frameSize
        mask.cornerRadius = cornerRadius
        pointer.frameSize = (short / 4).toEqualSize()
        pointer.toCircle()
//        pointer.placeViewInView(view: mask, position: .AlignTop, andPadding: 0)
        pointer.placeViewInView(view: mask, position: .AlignCenterX, andPadding: 0)
        pointer.alpha = error ? 0 : 1
        mask.transform = CGAffineTransformMakeRotation(radians)
        let d = degrees
        degreesLabel.text = error ? "?" : d.rounded(2).toString().appendIfNotNil("°")
        degreesLabel.textColor = degreesLabelColor
        
        if title == nil {
            degreesLabel.centerInView(self)
        } else {
            degreesLabel.sizeToFit()
            degreesLabel.placeViewInView(view: self, andPosition: .AlignCenterX)
            degreesLabel.placeViewInView(view: self, position: .AlignCenterY, andPadding: degreesLabel.frameHeight / 2)
        }
        
        titleLabel.textColor = degreesColor
        
    }
    
    
}




