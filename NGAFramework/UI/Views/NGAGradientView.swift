//
//  NGAGradientView.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 9/15/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGAGradientView: NGAView {
    public let gradientLayer = CAGradientLayer()
    public var colors:[UIColor]? {get{return convertCGColorsToUIColors(gradientLayer.colors)} set{gradientLayer.colors = convertUIColorsToCGColors(newValue)}}
    public var locations:[NSNumber]? {get{return gradientLayer.locations} set{gradientLayer.locations = newValue}}
    public var endPoint: CGPoint {get{return gradientLayer.endPoint} set{gradientLayer.endPoint = newValue}}
    public var startPoint: CGPoint {get{return gradientLayer.startPoint} set{gradientLayer.startPoint = newValue}}
    
    public override func postInit() {
        super.postInit()
        layer.addSublayer(gradientLayer)
    }
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        gradientLayer.frame = bounds
    }
    
    private func convertUIColorsToCGColors(colors:[UIColor]?) -> [AnyObject]? {
        if colors == nil {return nil}
        var temp:[AnyObject] = []
        for color in colors! {
            temp.append(color.CGColor as CGColorRef)
        }
        return temp
    }
    
    private func convertCGColorsToUIColors(colors:[AnyObject]?) -> [UIColor]? {
        if colors == nil {return nil}
        var temp = [UIColor]()
        for color in colors! {
            if let cgColor = color.CGColor {
                temp.append(UIColor(CGColor: cgColor))
            }
            
        }
        return temp
    }
    
    
}






