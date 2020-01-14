//
//  RawRepresntableExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 5/4/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

extension RawRepresentable {
    init?(raw:RawValue?) {
        guard let raw = raw, let val = Self(rawValue: raw) else {return nil}
        self = val
    }
}
