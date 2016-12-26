//
//  NSDateExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Date {
    public static var defaultDateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
    
    public static func date(from dateString:String?, withFormat formatString:String) -> Date?{
        guard let dateString = dateString else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.date(from: dateString)
    }
    
    
    public func toString(format:String? = nil) -> String? {
//        if format == nil {return description}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? Date.defaultDateFormat
        return dateFormatter.string(from: self)
    }
    
    public func toStyledString(dateStyle ds:DateFormatter.Style = .medium, timeStyle ts:DateFormatter.Style = .medium) -> String? {
        return DateFormatter.localizedString(from: self, dateStyle: ds, timeStyle: ts)
    }
    
}


