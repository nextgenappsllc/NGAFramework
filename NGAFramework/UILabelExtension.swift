//
//  UILabelExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UILabel {
//    @nonobjc public func fitFontToSizeOfText(t:String? = nil) {
//        let textToSize = t ?? text
//        font = font.fitFontToSize(frameSize, forString: textToSize)
//    }
    @nonobjc public func fitTextToSize(t:String? = nil) {
        let textToSize = t ?? text
        font = font.fitFontToSize(frameSize, forString: textToSize)
    }
    
    @nonobjc public func sizeToFitY(t:String? = nil) {
        let textToSize = t ?? text
        let l = UILabel()
        l.frame = frame
        l.attributedText = attributedText
        if !String.isEmptyOrNil(attributedText?.string) {
            l.attributedText = attributedText
        }else {
            l.text = textToSize
            l.font = font
        }
        l.sizeToFit()
        frameHeight = l.frameHeight
    }
    
    @nonobjc public func sizeToFitX(t:String? = nil) {
        let textToSize = t ?? text
        let l = UILabel()
        l.frame = frame
        if !String.isEmptyOrNil(attributedText?.string) {
            l.attributedText = attributedText
        }else {
            l.text = textToSize
            l.font = font
        }
        l.sizeToFit()
        frameWidth = l.frameWidth
    }
    
    func sizeToFitText(t:String? = nil) {
        let txt = t ?? text
        let l = UILabel()
        l.text = txt
        l.font = font
        l.frame = frame
        l.sizeToFit()
        frameSize = l.frameSize
    }
    
    public func fadeInText(txt:String? = nil) {
        let t = txt ?? text; let tArray = t?.substrings; let count = tArray?.count ?? 0
        if count == 0 {return}
        text = nil
        
        var currentText = ""
        
        //        var duration:UInt64 = 0
        //        let queue = dispatch_queue_create("labelqueue", DISPATCH_QUEUE_SERIAL)
        //        for var i = 0; i < count; i++ {
        ////            print("timer fired \(i) of \(count)")
        //
        //            let label = UILabel()
        //            label.alpha = 0
        //            label.backgroundColor = UIColor.clearColor()
        //            label.font = self.font
        //            label.textAlignment = self.textAlignment
        //            label.textColor = self.textColor
        //            label.numberOfLines = self.numberOfLines
        //            label.frame = self.bounds
        //
        //            let delay = NSEC_PER_MSEC * duration
        //            print(delay)
        //            let index = i
        //            dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
        //                if let s = tArray?.itemAtIndex(index) {currentText += s}
        //                label.text = currentText
        //                self.addSubview(label)
        //                //                    print("executing\(index) with delay \(delay)")
        //                UIView.animateWithDuration(0.25, animations: { () -> Void in
        //                    label.alpha = 1.0
        //                    }, completion: { (b:Bool) -> Void in
        //                        if label.text?.length ?? 0 > self.text?.length ?? 0 {
        //                            self.text = label.text
        //                        }
        //                        label.removeFromSuperview()
        //                        //                    if i >= count {self.text = t}
        //                })
        //
        //            })
        //
        //            duration += 250
        //
        //        }
        //
        var i = 0
        let timer = NSTimer.executeBlockWithDelay(0.2) { (timer:NSTimer?) -> Void in
            print("timer fired \(i) of \(count)")
            if let s = tArray?.itemAtIndex(i) {currentText += s}
            let label = UILabel()
            label.alpha = 0
            label.backgroundColor = self.backgroundColor
            label.font = self.font
            label.textAlignment = self.textAlignment
            label.textColor = self.textColor
            label.numberOfLines = self.numberOfLines
            label.frame = self.bounds
            label.text = currentText
            self.addSubview(label)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                label.alpha = 1.0
                }, completion: { (b:Bool) -> Void in
                    if label.text?.length ?? 0 > self.text?.length ?? 0 {
                        self.text = label.text
                    }
                    label.removeFromSuperview()
                    if i >= count {self.text = t}
            })
            i += 1
            if i >= count {print("invalidate");timer?.invalidate()}
        }
        
        timer.fire()
    }
}