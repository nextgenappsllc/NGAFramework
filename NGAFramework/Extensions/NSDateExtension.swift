//
//  NSDateExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension NSDate {
    class func dateFromString(dateString:String?, withFormat formatString:String) -> NSDate?{
        if dateString == nil {return nil}
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.dateFromString(dateString!)
    }
    
    
    func toString(format:String?) -> String? {
        if format == nil {return nil}
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func toStyledString(dateStyle ds:NSDateFormatterStyle? = nil, timeStyle ts:NSDateFormatterStyle? = nil) -> String? {
        
        if ds != nil && ts != nil {
            return NSDateFormatter.localizedStringFromDate(self, dateStyle: ds!, timeStyle: ts!)
        } else if let s = ds {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = s
            return dateFormatter.stringFromDate(self)
        } else if let s = ts {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = s
            return dateFormatter.stringFromDate(self)
        }
        return nil
    }
    
    func dateFromString(dateString:String?, withFormat formatString:String) -> NSDate?{
        if dateString == nil {return nil}
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.dateFromString(dateString!)
    }
}



public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
