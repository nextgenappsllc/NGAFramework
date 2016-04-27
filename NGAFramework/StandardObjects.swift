//
//  StandardObjects.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 4/20/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation


public protocol AllObjects:Loggable {}
extension Optional:AllObjects{}

public protocol StandardObjects:AllObjects {}
extension NSObject:StandardObjects{}
extension String:StandardObjects{}
extension Int:StandardObjects{}
extension Float:StandardObjects{}
extension CGFloat:StandardObjects{}
extension Double:StandardObjects{}
extension Bool:StandardObjects{}
extension Array:StandardObjects{}
extension Dictionary:StandardObjects{}


public protocol Numbers {}
extension Int:Numbers{}
extension Float:Numbers{}
extension CGFloat:Numbers{}
extension Double:Numbers{}




























