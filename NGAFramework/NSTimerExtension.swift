//
//  NSTimerExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension NSTimer {
    
    public class func executeBlockWithDelay(delay:Double, block:(NSTimer?) -> Void) -> NSTimer {
        let executor = TimerExecutor()
        executor.block = block
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: executor, selector: Selector("executeBlock"), userInfo: executor, repeats: true)
        executor.timer = timer
        return timer
    }
    
    
    
}
