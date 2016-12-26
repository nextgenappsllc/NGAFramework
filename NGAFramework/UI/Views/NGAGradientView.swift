//
//  NGAGradientView.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 9/15/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGAGradientView: NGAView {
    open let gradientLayer = CAGradientLayer()
    open var colors:[UIColor]? {get{return convertCGColorsToUIColors(gradientLayer.colors as SwiftArray?)} set{gradientLayer.colors = convertUIColorsToCGColors(newValue)}}
    open var locations:[NSNumber]? {get{return gradientLayer.locations} set{gradientLayer.locations = newValue}}
    open var endPoint: CGPoint {get{return gradientLayer.endPoint} set{gradientLayer.endPoint = newValue}}
    open var startPoint: CGPoint {get{return gradientLayer.startPoint} set{gradientLayer.startPoint = newValue}}
    
    open override func postInit() {
        super.postInit()
        layer.addSublayer(gradientLayer)
    }
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        gradientLayer.frame = bounds
    }
    
    fileprivate func convertUIColorsToCGColors(_ colors:[UIColor]?) -> SwiftArray? {
        if colors == nil {return nil}
        var temp:SwiftArray = []
        for color in colors! {
            temp.append(color.cgColor as CGColor)
        }
        return temp
    }
    
    fileprivate func convertCGColorsToUIColors(_ colors:SwiftArray?) -> [UIColor]? {
        if colors == nil {return nil}
        var temp = [UIColor]()
        for color in colors! {
            if let cgColor = (color as? UIColor)?.cgColor {
                temp.append(UIColor(cgColor: cgColor))
            }
            
        }
        return temp
    }
    
    
}






