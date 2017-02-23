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
        var base = "725754036feAbc21387430"
        15.times {_ in
            base += base
        }
        hexString = "0x" + base
    }
    
    override func tearDown() {
        super.tearDown()
        hexString = nil
    }
    
    
    func testHexFunctionsEqual() {
        let result1 = hexString!.convertFromHex()
        let result3 = Array<UInt8>(hex: hexString!)
        
        XCTAssert(result1 == result3, "Something isnt right!")
        
    }
    
    func testConvertFromHexPerformance() {
        var result:[UInt8]?
        self.measure {
            guard let hexString = self.hexString else {print("SKIPPING");return}
            result = hexString.convertFromHex()
        }
        print(result?.count ?? 0)
    }
    
    
    func testHexToBytesPerformance() {
        var result:[UInt8]?
        self.measure {
            guard let hexString = self.hexString else {print("SKIPPING");return}
            result = hexString.hexToBytes()
        }
        print(result?.count ?? 0)
    }
    
    func testArrayFromHexPerformance() {
        var result:[UInt8]?
        self.measure {
            guard let hexString = self.hexString else {print("SKIPPING");return}
            result = Array<UInt8>(hex: hexString)
        }
        print(result?.count ?? 0)
    }
    
//    func testArrayFromHex2Performance() {
//        var result:[UInt8]?
//        self.measure {
//            guard let hexString = self.hexString else {print("SKIPPING");return}
//            result = Array<UInt8>(hex2: hexString)
//        }
//        print(result?.count ?? 0)
//    }
    
    
}
