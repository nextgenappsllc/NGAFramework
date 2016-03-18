//
//  NGAAPIHelper.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/11/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


class NGAAPIHandler: NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
    
    typealias XMLResponseBlock = (NGAXMLElement!, String!) -> Void
    
    //MARK: Class
    //MARK: Properties
    
    
    //MARK: Methods
    class func composeURLStringFromBaseURL(baseURL:String?, parameters:[NSObject : AnyObject]?) -> String? {
        if baseURL == nil {return nil}
        var urlString = baseURL!
        if let params = parameters {
//            if params.count > 0 {urlString! += "?"}
            var i = 0
            for (key, value) in params {
                let prefix = i == 0 ? "?" : "&"
                urlString += prefix
                let k = NSString.stringForURLFromString("\(key)")
                let v = NSString.stringForURLFromString("\(value)")
                urlString += "\(k)=\(v)"
                i++
            }
        }
//        print(urlString)
        return urlString
    }
    

    
    
    class func composePostDataAndRequestForURLString(urlString:String? ,parameters:[NSObject:AnyObject]?) -> (request:NSURLRequest?, data:NSData?) {
        var temp:(request:NSURLRequest?, data:NSData?) = (nil,nil)
        let url = urlString?.url
        let urlRequest = url?.toMutableRequest()
        urlRequest?.HTTPMethod = NGAHttpStrings.postMethod
        temp.request = urlRequest
        if var params = parameters {
            let boundary = "4737809831466499882746641449"
            let startSeperator = "--\(boundary)\r\n"
            let endSeperator = "--\(boundary)--\r\n"
            urlRequest?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: NGAHttpStrings.contentTypeHeaderField)
            let body = NSMutableData()
            let fileNames = params.mapToNewDictionary({ (key:NSObject, value:AnyObject) -> AnyObject? in
                let temp = parameters?["\(key)-filename"]
                return temp
            })
            for key in Array(fileNames.keys) { params["\(key)-filename"] = nil }
            
            func appendStringToData(str:String?) {
                if let d = str?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {body.appendData(d)}
            }
            
            for (key, value) in params {
                appendStringToData(startSeperator)
                
                let fileName = fileNames.stringForKey(key) ?? key
                
                var contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\""
                contentDispositionString += value is NSData ? "; filename=\"\(fileName)\"\r\n" : "\r\n"
                appendStringToData(contentDispositionString)
                
                let contentTypeString = value is NSData ? "Content-Type: application/octet-stream\r\n\r\n" : "Content-Type: text/plain\r\n\r\n"
                appendStringToData(contentTypeString)
                
                if let d = value as? NSData { body.appendData(d) } else { appendStringToData("\(value)")}
                
                appendStringToData("\r\n")
                
            }
            if params.count > 0 {appendStringToData(endSeperator)}
            
            temp.data = body.copy() as? NSData
        }
        
        
        return temp
    }
    
    //MARK: For testing
    class func printPostDataForURLString(urlString:String? ,parameters:[NSObject:AnyObject]?) {

        if var params = parameters {
            //            print("before params")
            let boundary = "4737809831466499882746641449"
            let startSeperator = "--\(boundary)\r\n"
            let endSeperator = "--\(boundary)--\r\n"
            var body = ""
            let fileNames = params.mapToNewDictionary({ (key:NSObject, value:AnyObject) -> AnyObject? in
                let temp = parameters?["\(key)-filename"]
                return temp
            })
            //            print(fileNames)
            for key in Array(fileNames.keys) {
                params["\(key)-filename"] = nil
            }
            //            print("after params", params)
            for (key, value) in params {
                //                print(key, value is NSData ? "<DATA>" : value)
                body += startSeperator
                let fileName = fileNames.stringForKey(key) ?? key
                body += value is NSData ? "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n" : "Content-Disposition: form-data; name=\"\(key)\"\r\n"
                body += value is NSData ? "Content-Type: application/octet-stream\r\n\r\n" : "Content-Type: text/plain\r\n\r\n"
                body += "\(value)\r\n"
            }
            if params.count > 0 {
                body += endSeperator
            }
            
            print(body)
        }
        
        
        
    }
    
    
    
    //MARK: Instance
    //MARK: Generic
    //MARK: Properties
    
    lazy var defaultDataSession:NSURLSession = {
        var urlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        var urlSession = NSURLSession(configuration: urlSessionConfig, delegate: self, delegateQueue: nil)
        return urlSession
        }()
    
    
    var dataTaskCompletionBlock:NetworkResponseBlock?
    var mutableDataTaskData:NSMutableData?
    var dataTaskURLResponse:NSURLResponse?
    var dataTaskError:NSError?
    var dataTaskUpdateBlock:DataProgressBlock?
    
    
    //MARK: Methods
    
    
    func startDataURLSessionWithString(urlString:String, andCompletionBlock block:NetworkResponseBlock?) {
        let url = NSURL(string: urlString)
        if url != nil {
            let urlRequest = NSURLRequest(URL: url!)
            let urlSession = defaultDataSession
            let task = block == nil ? urlSession.dataTaskWithRequest(urlRequest) : urlSession.dataTaskWithRequest(urlRequest, completionHandler: block!)
            task.resume()
        }
    }
    
    func startDownloadURLSessionWithString(urlString:String, andCompletionBlock block:URLReturnBlock?) {
        let url = NSURL(string: urlString)
        if url != nil {
            let urlRequest = NSURLRequest(URL: url!)
            let urlSession = defaultDataSession
            let task = block == nil ? urlSession.downloadTaskWithRequest(urlRequest) : urlSession.downloadTaskWithRequest(urlRequest, completionHandler: block!)
            task.resume()
        }
    }
    
    func startDataURLSessionWithString(urlString:String, andXMLCompletionBlock completionBlock:XMLResponseBlock) {
        let url = NSURL(string: urlString)
        if url != nil {
            let urlRequest = NSURLRequest(URL: url!)
            let urlSession = defaultDataSession
            let processXMLBlock:NetworkResponseBlock = { (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) in
                if data != nil && error ==  nil {
//                    var dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                    if let error = self.checkDataForError(data) {
//                        
//                    }
//                    else {
                        let parser = NSXMLParser(data: data!)
                        let parserDelegate = NGAXMLParserDelegate()
                        parser.delegate = parserDelegate
                        parser.parse()
                        if parserDelegate.firstElementName != nil {
                            let mainElement = NGAXMLElement(elementName: parserDelegate.firstElementName!, and: parserDelegate.parsedDictionary as [NSObject : AnyObject])
                            completionBlock(mainElement, nil)
                        }
//                    }
                }
                else if error != nil {
                    let errorMessage = "An error occured please try again"
                    completionBlock(nil, errorMessage)
                }
                else {
                    completionBlock(nil, nil)
                }
            }
            let task = urlSession.dataTaskWithRequest(urlRequest, completionHandler: processXMLBlock)
            task.resume()
        }
    }
    
    func startUploadURLSessionWithString(urlString urlString:String, httpParams:NSDictionary?, data:NSData?, andXMLCompletionBlock completionBlock:XMLResponseBlock) {
        let url = NSURL(string: urlString)
        if url != nil {
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = NGAHttpStrings.postMethod
            var postLength = 0
            if data != nil {
                postLength = data!.length
            }
            urlRequest.setValue("\(postLength)", forHTTPHeaderField: NGAHttpStrings.contentLengthHeaderField)
            if let nonNilParams = httpParams {
                for (key, value) in nonNilParams {
                    if let keyString = key as? String {
                        if let valueString = value as? String {
                            urlRequest.setValue(valueString, forHTTPHeaderField: keyString)
                        }
                    }
                    
                }
            }
            
            let processXMLBlock:NetworkResponseBlock = { (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) in
                if data != nil && error ==  nil {
//                    var dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                    //                    println(dataString)
//                    if let error = self.checkDataForError(data) {
//                        
//                    }
//                    else {
                        let parser = NSXMLParser(data: data!)
                        let parserDelegate = NGAXMLParserDelegate()
                        parser.delegate = parserDelegate
                        parser.parse()
                        if parserDelegate.firstElementName != nil {
                            let mainElement = NGAXMLElement(elementName: parserDelegate.firstElementName!, and: parserDelegate.parsedDictionary as [NSObject : AnyObject])
                            completionBlock(mainElement, nil)
                        }
//                    }
                }
                else if error != nil {
                    let errorMessage = "An error occured please try again"
                    completionBlock(nil, errorMessage)
                }
                else {
                    completionBlock(nil, nil)
                }
                
            }
            
            
            let urlSession = defaultDataSession
            let task = urlSession.uploadTaskWithRequest(urlRequest, fromData: data, completionHandler: processXMLBlock)
            task.resume()
        }
    }
    
    
    
    func responseReturnedWith(data data:NSData?, urlResponse:NSURLResponse?, andError error:NSError?) {
        if error == nil && data != nil {
            
        }
    }
    
    
    //MARK: Session delegate
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print("session became invalid")
    }

    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        //// add trusted hosts 
        
        
        
        //        println("session recieved challange \(challenge.protectionSpace)")
        let trusted = challenge.protectionSpace.host.containsString("mcmglobalsa.com", caseInsensitive: true)
        let disposition = trusted ? NSURLSessionAuthChallengeDisposition.UseCredential : NSURLSessionAuthChallengeDisposition.PerformDefaultHandling
//        print(disposition, challenge.proposedCredential)
//        let authDisposition = NSURLSessionAuthChallengeDisposition.PerformDefaultHandling
        let credential = trusted && challenge.protectionSpace.serverTrust != nil ? NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)  : challenge.proposedCredential
//        print(credential, trusted)
        completionHandler(disposition, credential)
    }
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("session did finish background")
    }
    
    //MARK: Session Task Delegate
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("completed :: error = \(error?.description)")
        if let completionBlock = dataTaskCompletionBlock {
            completionBlock(mutableDataTaskData?.copy() as? NSData, dataTaskURLResponse, error)
        }
        mutableDataTaskData = nil
        dataTaskURLResponse = nil
        dataTaskUpdateBlock = nil
        session.resetWithCompletionHandler { () -> Void in
            
        }
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        print("did receive auth challenge")
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        print("sent some body data!")
//        if self.dataTaskUpdateBlock == nil {print("no update block in urlsessiontask")}
//        if let block = dataTaskUpdateBlock {
            let size = Int(bytesSent) ; let expectedSize = Int(totalBytesExpectedToSend)
//        print(bytesSent, totalBytesSent, totalBytesExpectedToSend)
            let mainBlock:VoidBlock = {
                self.dataTaskUpdateBlock?(size, expectedSize, task)
            }
            dispatch_async(dispatch_get_main_queue(), mainBlock)
//        }
        
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        print("url session needs new body stream")
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        print("url session is redirecting")
    }
    
    //MARK: Session Download delegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("finished download!")
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("resumed at offset")
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Wrote data!")
    }
    
    //MARK: Session Data delegate
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        print("became download task")
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        print("Receiving data!")
        if mutableDataTaskData == nil {mutableDataTaskData = NSMutableData()}
        mutableDataTaskData?.appendData(data)
        
        if let block = dataTaskUpdateBlock {
            let size = data.length
            let mainBlock:VoidBlock = {
//                print(size, -1, dataTask)
                block(size, -1, dataTask)
            }
            dispatch_async(dispatch_get_main_queue(), mainBlock)
        }
        
        
        
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        //        println("Received response \(response.description)")
        dataTaskURLResponse = response
        let responseDisposition = NSURLSessionResponseDisposition.Allow
        completionHandler(responseDisposition)
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        print("will cache response!")
        completionHandler(proposedResponse)
    }
    
    //MARK: POST
    func postRequestToURLString(urlString:String?, parameters:[NSObject:AnyObject]?, completionBlock:NetworkResponseBlock?, progressUpdateBlock:DataProgressBlock? = nil) {
//        print(parameters?.toJSONSafe().toJSONData(true)?.toString())
        let requestAndData = NGAAPIHandler.composePostDataAndRequestForURLString(urlString, parameters: parameters)
        if let urlRequest = requestAndData.request {
            let nullBlock:NetworkResponseBlock = {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                print("null block executed")
            }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.uploadTaskWithRequest(urlRequest, fromData: requestAndData.data , completionHandler: finalBlock)
            
            task.resume()
        }

    }
    
    func postRequestToURL(url:NSURL?, withParameters parameters:NSDictionary?, andCompletionBlock completionBlock:NetworkResponseBlock?, andProgressUpdateBlock progressUpdateBlock:DataProgressBlock? = nil) {
//        print((parameters as? [NSObject:AnyObject])?.toJSONSafe().toJSONData(true)?.toString())
        let requestAndData = NGAAPIHandler.composePostDataAndRequestForURLString(url?.absoluteString, parameters: parameters as? [NSObject:AnyObject])
        if let urlRequest = requestAndData.request {
            let nullBlock:NetworkResponseBlock = {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                print("null block executed")
            }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.uploadTaskWithRequest(urlRequest, fromData: requestAndData.data , completionHandler: finalBlock)
            
            task.resume()
        }

    }
    
    
    
    
    
    // MARK: GET
    
    func getRequestToURLString(var urlString:String?, parameters:[NSObject:AnyObject]?, completionBlock:NetworkResponseBlock?, progressUpdateBlock:DataProgressBlock? = nil) {
        urlString = NGAAPIHandler.composeURLStringFromBaseURL(urlString, parameters: parameters)
        if let urlRequest = urlString?.url?.toMutableRequest() {
            urlRequest.HTTPMethod = NGAHttpStrings.getMethod
            let nullBlock:NetworkResponseBlock = {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                print("null block executed")
                
            }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.dataTaskWithRequest(urlRequest, completionHandler: finalBlock)
            task.resume()
        }
    }
    
    func getRequestToURL(url:NSURL?, andCompletionBlock completionBlock:NetworkResponseBlock?, andProgressUpdateBlock progressUpdateBlock:DataProgressBlock? = nil) {
        if url != nil{
            let cURL = url!
            let urlRequest = NSMutableURLRequest(URL: cURL)
            urlRequest.HTTPMethod = NGAHttpStrings.getMethod
            
            let nullBlock:NetworkResponseBlock = {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                print("null block executed")
            }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.dataTaskWithRequest(urlRequest, completionHandler: finalBlock)
            task.resume()
            
        }
    }
    
    
    // MARK: delete
    
    func deleteRequestToURLString(var urlString:String?, parameters:[NSObject:AnyObject]?, completionBlock:NetworkResponseBlock?, progressUpdateBlock:DataProgressBlock? = nil) {
        urlString = NGAAPIHandler.composeURLStringFromBaseURL(urlString, parameters: parameters)
        if let urlRequest = urlString?.url?.toMutableRequest() {
            urlRequest.HTTPMethod = NGAHttpStrings.deleteMethod
            let nullBlock:NetworkResponseBlock = {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                print("null block executed")
                
            }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.dataTaskWithRequest(urlRequest, completionHandler: finalBlock)
            task.resume()
        }
    }
    
    //MARK: Patch
    func patchRequestToURLString(urlString:String?, parameters:[NSObject:AnyObject]?, completionBlock:NetworkResponseBlock?, progressUpdateBlock:DataProgressBlock? = nil) {
        let requestAndData = NGAAPIHandler.composePostDataAndRequestForURLString(urlString, parameters: parameters)
        if let urlRequest = requestAndData.request?.mutableCopy() as? NSMutableURLRequest {
            urlRequest.HTTPMethod = "PATCH"
            
            let nullBlock:NetworkResponseBlock = {(d,r,e) in }
            let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
            
            self.dataTaskUpdateBlock = progressUpdateBlock
            let task = defaultDataSession.uploadTaskWithRequest(urlRequest, fromData: requestAndData.data , completionHandler: finalBlock)
            
            task.resume()
        }
        
    }
    
    
    func checkDataForError(data:NSData?) -> NSError? {
        return nil
    }
    
    
}


struct NGAHttpStrings {
    static let postMethod = "POST"
    static let getMethod = "GET"
    static let deleteMethod = "DELETE"
    static let contentLengthHeaderField = "Content-Length"
    static let contentTypeHeaderField = "Content-Type"
    static let contentTypeWWWFormUrlEncoded = "application/x-www-form-urlencoded"
}


















