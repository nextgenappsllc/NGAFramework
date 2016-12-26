//
//  NGATypeAliases.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 5/19/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit
//import CoreData


public typealias SwiftArray = [Any]
public typealias SwiftDictionary = [AnyHashable: Any]
public typealias VoidBlock = () -> Void
public typealias NetworkResponseBlock = (Data?, URLResponse?, Error?) -> Void

public typealias DataProgressBlock = (Int, Int, URLSessionTask?) -> Void

public typealias AlertActionBlock = (UIAlertAction) -> Void


//// possibly deprecating or refactoring these
//typealias ArrayFetchCompletionBlock = (_ array:SwiftArray?, _ urlResponse:URLResponse?, _ andError: NSError?) -> Void
//typealias LoginResponseCallBackBlock = (Bool, String?) -> Void
//typealias DictionaryFetchCompletionBlock = (_ dictionary:NSDictionary?, _ urlResponse:URLResponse?, _ error: NSError?) -> Void
//typealias FileURLReturnBlock = (URL?, NSError?) -> Void
//typealias URLReturnBlock = (URL?, URLResponse?, NSError?) -> Void
//typealias SuccessCompletionBlock = (_ success:Bool, _ error:Error?) -> Void
//
//typealias ArrayReturnBlock = (SwiftArray?) -> Void
//typealias DictionaryReturnBlock = (NSDictionary?) -> Void
//typealias ImageReturnBlock = (UIImage?) -> Void
//typealias ArrayAndErrorBlock = (SwiftArray?, Error?) -> Void
//typealias FetchReturnBlock = (Any?, Error?, Bool) -> Void //// Yes if local


