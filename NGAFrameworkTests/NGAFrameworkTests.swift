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
        hexString = "0x" + base
    }
    
    override func tearDown() {
        super.tearDown()
        hexString = nil
    }
    
    
    func testConvertFromHexPerformance() {
        var result:[UInt8]?
        self.measure {
            guard let hexString = self.hexString else {print("SKIPPING");return}
            result = hexString.convertFromHex()
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
    
//    func testArrayFromUtf8HexPerformance() {
//        var result:[UInt8]?
//        self.measure {
//            guard let hexString = self.hexString else {print("SKIPPING");return}
//            result = Array(hexString.utf8)
//        }
//        print(result?.count ?? 0)
//    }
    
//    func testRegexPerformance() {
//        let str = "72"
//        measure {
//            let range = Range<String.Index>(uncheckedBounds: (lower: str.startIndex, upper: str.endIndex))
//            self.hexString?.range(of: "72", options: .regularExpression, range: range, locale: nil)
//        }
//        
//    }
//    func testHasPrefixPerformance(){
//        let str = "72"
//        measure {
//            self.hexString?.hasPrefix(str)
//        }
//    }
    
}
