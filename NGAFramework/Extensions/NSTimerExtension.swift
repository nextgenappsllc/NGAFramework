//
//  NSTimerExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Timer {
    
    public class func executeBlockWithDelay(_ delay:Double, block:@escaping (Timer?) -> Void) -> Timer {
        let executor = TimerExecutor()
        executor.block = block
        let timer = Timer.scheduledTimer(timeInterval: delay, target: executor, selector: #selector(TimerExecutor.executeBlock), userInfo: executor, repeats: true)
        executor.timer = timer
        return timer
    }
    
    
    
}
