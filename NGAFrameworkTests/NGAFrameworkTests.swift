//
//  NGAFrameworkTests.swift
//  NGAFrameworkTests
//
//  Created by Jose Castellanos on 2/13/17.
//  Copyright © 2017 NextGen Apps LLC. All rights reserved.
//

import XCTest
@testable import NGAFramework

class NGAFrameworkTests: XCTestCase {
    var hexString:String?
    override func setUp() {
        super.setUp()
        var base = "725754036feabc21387430"
        15.times {_ in
            base += base
        }
        hexString = base
    }
    
    override func tearDown() {
        super.tearDown()
        hexString = nil
    }
    
    
    func testConvertFromHexPerformance() {
        var result:[UInt8]?
        self.measure {
            result = self.hexString?.convertFromHex()
        }
        print(result?.count ?? 0)
    }
    
}
