//
//  NSDateExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

extension Date {
    static var defaultDateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
    
    static func date(from dateString:String?, withFormat formatString:String) -> Date?{
        guard let dateString = dateString else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.date(from: dateString)
    }
    
    
    func toString(format:String? = nil) -> String? {
//        if format == nil {return description}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? Date.defaultDateFormat
        return dateFormatter.string(from: self)
    }
    
    func toStyledString(dateStyle ds:DateFormatter.Style = .medium, timeStyle ts:DateFormatter.Style = .medium) -> String? {
        return DateFormatter.localizedString(from: self, dateStyle: ds, timeStyle: ts)
    }
    
}


