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


public typealias SwiftArray = [AnyObject]
public typealias SwiftDictionary = [NSObject:AnyObject]
public typealias VoidBlock = () -> Void
public typealias NetworkResponseBlock = (NSData?, NSURLResponse?, NSError?) -> Void

public typealias DataProgressBlock = (Int, Int, NSURLSessionTask?) -> Void




//// possibly deprecating or refactoring these
typealias ArrayFetchCompletionBlock = (array:NSArray?, urlResponse:NSURLResponse?, andError: NSError?) -> Void
typealias LoginResponseCallBackBlock = (Bool, String?) -> Void
typealias DictionaryFetchCompletionBlock = (dictionary:NSDictionary?, urlResponse:NSURLResponse?, error: NSError?) -> Void
typealias FileURLReturnBlock = (NSURL?, NSError?) -> Void
typealias URLReturnBlock = (NSURL?, NSURLResponse?, NSError?) -> Void
typealias SuccessCompletionBlock = (success:Bool, error:NSError?) -> Void
typealias AlertActionBlock = (UIAlertAction) -> Void
typealias ArrayReturnBlock = (NSArray?) -> Void
typealias DictionaryReturnBlock = (NSDictionary?) -> Void
typealias ImageReturnBlock = (UIImage?) -> Void
typealias ArrayAndErrorBlock = (NSArray?, NSError?) -> Void
typealias FetchReturnBlock = (AnyObject?, NSError?, Bool) -> Void //// Yes if local


