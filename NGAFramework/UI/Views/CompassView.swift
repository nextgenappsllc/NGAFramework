//
//  CompassView.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/29/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

open class CompassView: NGAView {
    open let viewMask = UIView()
    open let nLabel = UILabel()
    open let eLabel = UILabel()
    open let sLabel = UILabel()
    open let wLabel = UILabel()
    open let pointer = UIView()
    open let degreesLabel = UILabel()
    open let titleLabel = UILabel()
    open var title:String? {
        didSet {
            setFramesForSubviews()
        }
    }
    
    open var errorColor:UIColor? = UIColor.red {
        didSet {
            if errorColor != oldValue {
                if error { degreesLabel.textColor = errorColor }
            }
        }
    }
    open var pointerColor:UIColor? = UIColor.blue {
        didSet {
            pointer.backgroundColor = pointerColor
        }
    }
    open var degreesColor:UIColor? = UIColor.darkGray {
        didSet {
            if degreesColor != oldValue {
                if !error { degreesLabel.textColor = degreesColor }
            }
        }
    }
    open var degreesLabelColor:UIColor? {get{return error ? errorColor : degreesColor}}
    open var coordinateColor:UIColor? = UIColor.black {
        didSet {
            if coordinateColor != oldValue {
                for label in coordinateLabels {
                    label.textColor = coordinateColor
                }
            }
        }
    }
    
    open var negativeValueError:Bool = true {didSet{if oldValue != negativeValueError {setMaskFrame()}}}
    open var error:Bool {get{return negativeValueError ? radians < 0 : false}}
    
    open var constrainDegreesTo360:Bool = true {didSet{if constrainDegreesTo360 != oldValue {setMaskFrame()}}}
    
    open var coordinateLabels:[UILabel] {get{ return [nLabel, eLabel, sLabel, wLabel]}}
    open var font:UIFont? = UIFont(name: NGAFontNames.HelveticaNeueUltraLight, size: 12.0) {
        didSet {
            if font != oldValue {setFramesForSubviews()}
        }
    }
    
    open var degrees:CGFloat {
        get {
            var d = (radians.toDouble() * 180 / .pi).toCGFloat()
            if !constrainDegreesTo360 {return d}
            while d > 360 {d -= 360}
            return d
        }
        set {radians = (newValue.toDouble() * .pi / 180).toCGFloat()}
    }
    open var radians:CGFloat = 0 {
        didSet{
            if oldValue != radians {
                setMaskFrame()
            }
        }
    }
    
    
    open override func postInit() {
        super.postInit()
        nLabel.text = "N"
        eLabel.text = "E"
        sLabel.text = "S"
        wLabel.text = "W"
        addSubview(viewMask)
        for label in coordinateLabels {
            addSubview(label)
            label.textAlignment = .center
            label.textColor = coordinateColor
        }
        degreesLabel.textAlignment = .center
        degreesLabel.textColor = degreesLabelColor
        titleLabel.textColor = degreesColor
        addSubview(degreesLabel)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        viewMask.addSubview(pointer)
        viewMask.backgroundColor = UIColor.clear
        pointer.backgroundColor = pointerColor
    }
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        toCircle()
        let short = shortSide
        var s = short / 4
        for label in coordinateLabels {
            label.font = font
            label.frameSize = CGSize(width: s, height: s)
            label.fitTextToSize()
        }
        for label in [eLabel, wLabel] {
            label.placeViewInView(view: self, andPosition: .alignCenterY)
        }
        for label in [nLabel, sLabel] {
            label.placeViewInView(view: self, andPosition: .alignCenterX)
        }
        nLabel.placeViewInView(view: self, position: .alignTop, andPadding: 0)
        eLabel.placeViewInView(view: self, position: .alignRight, andPadding: 0)
        sLabel.placeViewInView(view: self, position: .alignBottom, andPadding: 0)
        wLabel.placeViewInView(view: self, position: .alignLeft, andPadding: 0)
        
        
        s *= 2
//        degreesLabel.fitViewInCiricleWithRadius(s)
        degreesLabel.frameSize = CGSize(width: s, height: s / 2)
        degreesLabel.font = font
        let text = degreesLabel.text
        degreesLabel.text = "999..99°"
        degreesLabel.fitTextToSize()
        degreesLabel.text = text
        
        
        
        titleLabel.frameSize = CGSize(width: s, height: s / 2)
        titleLabel.numberOfLines = 0
//        titleLabel.fitViewInCiricleWithRadius(s)
        titleLabel.font = font
        titleLabel.text = title
        titleLabel.fitTextToSize()
        titleLabel.sizeToFit()
        titleLabel.placeViewInView(view: self, andPosition: .alignCenterX)
        titleLabel.placeViewInView(view: self, position: .alignCenterY, andPadding: -titleLabel.frameHeight / 2)
        
        
        setMaskFrame()
        
    }
    
    open func setMaskFrame() {
        viewMask.transform = CGAffineTransform(rotationAngle: 0)
        let short = shortSide
        viewMask.frameSize = frameSize
        viewMask.cornerRadius = cornerRadius
        pointer.frameSize = (short / 4).toEqualSize()
        pointer.toCircle()
//        pointer.placeViewInView(view: mask, position: .AlignTop, andPadding: 0)
        pointer.placeViewInView(view: viewMask, position: .alignCenterX, andPadding: 0)
        pointer.alpha = error ? 0 : 1
        viewMask.transform = CGAffineTransform(rotationAngle: radians)
        let d = degrees
        degreesLabel.text = error ? "?" : d.rounded(2).toString().appendIfNotNil("°")
        degreesLabel.textColor = degreesLabelColor
        
        if title == nil {
            degreesLabel.centerInView(self)
        } else {
            degreesLabel.sizeToFit()
            degreesLabel.placeViewInView(view: self, andPosition: .alignCenterX)
            degreesLabel.placeViewInView(view: self, position: .alignCenterY, andPadding: degreesLabel.frameHeight / 2)
        }
        
        titleLabel.textColor = degreesColor
        
    }
    
    
}




