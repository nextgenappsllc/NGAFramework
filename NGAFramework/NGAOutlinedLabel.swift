//
//  NGAOutlinedLabel.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 3/5/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit



//// deprecate
class NGAOutlineLabel: UILabel {
    
    var innerLabel = UILabel()
    
    var outlineScale:CGFloat = 0.9
    
    override var text:String? {
        didSet {
            innerLabel.text = text
            self.addSubview(self.innerLabel)
        }
    }
    
    override var font:UIFont! {
        didSet {
            innerLabel.font = font.fontWithSize(font.pointSize * outlineScale)
        }
    }
    
    override var textColor:UIColor! {
        didSet {
            innerLabel.textColor = UIColor.oppositeColorOf(textColor)
        }
    }
    
    override var textAlignment:NSTextAlignment {
        didSet {
            innerLabel.textAlignment = textAlignment
        }
    }
    
    override var frame:CGRect {
        didSet {
            innerLabel.frame = bounds
            innerLabel.setSizeFromView(self, withXRatio: outlineScale, andYRatio: outlineScale)
            innerLabel.centerInView(self)
//            println("inner label frame \(innerLabel.frame)")
        }
    }
    
    
//    override init() {
//        super.init()
////        println("init")
//        
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        innerLabel.text = self.text
        innerLabel.font = self.font.fontWithSize(font.pointSize)
        innerLabel.textColor = UIColor.oppositeColorOf(self.textColor)
        innerLabel.textAlignment = self.textAlignment
        
        
        self.addSubview(self.innerLabel)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    
}