//
//  CoreLocationExtensions.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 4/1/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import CoreLocation


public extension CLLocationCoordinate2D {
    public func latitudeString(_ decimalFormat:Bool = false) -> String {
        let hemisphere = latitude < 0 ? "S" : "N"
        return decimalFormat ? latitude.rounded(7).toString().appendIfNotNil(String.degrees) : CLLocationCoordinate2D.coordinateStringFromDecimal(latitude).appendIfNotNil(hemisphere)
    }
    public func longitudeString(_ decimalFormat:Bool = false) -> String {
        let hemisphere = longitude < 0 ? "W" : "E"
        return decimalFormat ? longitude.rounded(7).toString().appendIfNotNil(String.degrees) : CLLocationCoordinate2D.coordinateStringFromDecimal(longitude).appendIfNotNil(hemisphere)
    }
    public static func coordinateStringFromDecimal(_ coordinate:Double) -> String {
        let c = abs(coordinate)
        var seconds = c * 3600
        let degrees = seconds.toInt() / 3600
        let minutes = ((c - degrees.toDouble()) * 3600).toInt() / 60
        seconds = ((c - (degrees.toDouble() + minutes.toDouble() / 60)) * 3600)
        return degrees.toString().appendIfNotNil(String.degrees).appendIfNotNil(minutes.toString()).appendIfNotNil("'").appendIfNotNil(seconds.rounded(1).toString()).appendIfNotNil("\"")
    }
}
