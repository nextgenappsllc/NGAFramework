//: Playground - noun: a place where people can play

import UIKit
import NGAFramework
import PlaygroundSupport
//import CryptoSwift

PlaygroundPage.current.needsIndefiniteExecution = true


//var i:UInt16 = 0xff00
//
//i.littleEndian
//i.bigEndian
//
//let arr = withUnsafeBytes(of: &i) { (rawBufferPointer) in
//    Array(rawBufferPointer)
////    print(a)
////    return a
//}
//arr
//
////let hexString = arr.toHexString()
//
////hexString.hexToBytes()
////
////hexString.hexToBytes().toHexString()
//
//var bytes = "ff00".hexToBytes()
//(18 << 8) + 52
//(52 << 8) + 18
//
//arr.toHexString()
//
//Data(bytes: arr).withUnsafeBytes { (b:UnsafePointer<Int>) -> Int in
//    return b.pointee
//}
//
//Data(bytes: bytes).withUnsafeBytes { (b:UnsafePointer<Int>) -> Int in
//    return b.pointee
//}
//
//Data(bytes: [0,0,0,0,0,0,18,52]).withUnsafeBytes { (b:UnsafePointer<Int>) -> Int in
//    return b.pointee
//}
let predicate = DispatchPredicate.onQueue(DispatchQueue.main)

var mainKey = DispatchSpecificKey<Any>()
var backgroundKey = DispatchSpecificKey<Any>()
var mainValue = "com.ngaFramework.mainQueue"
var backgroundValue = "com.ngaFramework.backgroundQueue"

DispatchQueue.main.setSpecific(key: mainKey, value: ())

var backgroundQueue = DispatchQueue(label: backgroundValue)
backgroundQueue.setSpecific(key: backgroundKey, value: ())


// withUnsafePointer(to: &mainKey) { print(String(describing: $0))}
// withUnsafePointer(to: &mainValue) { print(String(describing: $0))}

// withUnsafePointer(to: &backgroundKey) { print(String(describing: $0))}
// withUnsafePointer(to: &backgroundValue) { print(String(describing: $0))}


var specific = DispatchQueue.getSpecific(key: mainKey)
withUnsafePointer(to: &specific) { print(String(describing: $0))}

backgroundQueue.async {
    var specific = DispatchQueue.getSpecific(key: mainKey)
    withUnsafePointer(to: &specific) { print(String(describing: $0))}
    NGAExecute.performOnMainQueue({ 
        var specific = DispatchQueue.getSpecific(key: mainKey)
        withUnsafePointer(to: &specific) { print(String(describing: $0))}
    })
    DispatchQueue.main.async {
        var specific = DispatchQueue.getSpecific(key: mainKey)
        withUnsafePointer(to: &specific) { print(String(describing: $0))}
        NGAExecute.performOnMainQueue({
            var specific = DispatchQueue.getSpecific(key: mainKey)
            withUnsafePointer(to: &specific) { print(String(describing: $0))}
        })
    }
}

func performOnMainQueue(_ b:VoidBlock?){
    if b == nil {return}
    
    
}


func performOnMainThread(_ b:VoidBlock?) {
    if b == nil {return}
    if Thread.isMainThread {
        b?()
    } else {
        DispatchQueue.main.async(execute: b!)
    }
}


//dispatchPrecondition(condition: predicate)

