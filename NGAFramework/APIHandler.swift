//
//  APIHandler.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/17/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public class APIHandler: NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
    
    /**
     Adds values to the url string with the format key=value and url encodes the values.
     
     The key and value are interpolated into the string like "\(value)" so typically strings numbers and bools are best to use.
     The output is a string in the follwing format: "\(url)?\(k1)=\(v1)&(k2)=(v2)..."
     
     - Parameter url: The url to send the request to as a String.
     
     - Parameter parameters: A dictionary ([NSObject:AnyObject]) containing the key value pairs to add.
     
     - Returns: A string containing the base url with the parameters added to it.
     */
    public class func urlStringWithParameters(url:String, parameters:SwiftDictionary?) -> String {
        var r = url
        guard let params = parameters else {return r}
        var i = 0
        for (key, value) in params {
            let prefix = i == 0 ? "?" : "&"
            r += prefix
            let k = "\(key)".urlEncode() ; let v = "\(value)".urlEncode()
            r += "\(k)=\(v)"
            i += 1
        }
        return r
    }
    
    /**
     Encodes the key value pairs as multiform data seperated by the specified boundary string.
     
     For files you want to add the data and filename in the dictionary as follows:
     
     ["file":fileData, "file-filename": "myFile.pdf", "otherFile": otherFileData, "otherFile-filename", "anotherOne.png"]
     
     - Parameter boundary: The boundary as a string. It should be a long alphanumeric string.
     
     - Parameter parameters: A dictionary ([NSObject:AnyObject]) containing the key value pairs to add.
     
     - Returns: The multiform data comprised of the key value pairs in the dictionary.
     */
    public class func createMultiFormData(boundary:String, parameters:SwiftDictionary?) -> NSData? {
        guard var params = parameters else {return nil}
        let startSeperator = "--\(boundary)\r\n"
        let endSeperator = "--\(boundary)--\r\n"
        let body = NSMutableData()
        let fileNames = params.mapToNewDictionary(){(key, value) -> AnyObject? in return parameters?["\(key)-filename"]}
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
        return body.copy() as? NSData
    }

    
    public func sendRequestTo(url:String, method:HTTPMethod = .GET, urlParameters:SwiftDictionary? = nil, multiFormParameters:SwiftDictionary? = nil, progressBlock:DataProgressBlock? = nil, completionBlock:NetworkResponseBlock?) -> NSURLSessionTask? {
        let urlString = self.dynamicType.urlStringWithParameters(url, parameters: urlParameters)
        guard let request = urlString.url?.toMutableRequest() else {return nil}
        request.HTTPMethod = method.rawValue
        let nullBlock:NetworkResponseBlock = {(d,r,e) in }
        let finalBlock = completionBlock == nil ? nullBlock : completionBlock!
        let task:NSURLSessionTask
        if let data = self.dynamicType.createMultiFormData(multiFormBoundary, parameters: multiFormParameters) {
            request.setValue("multipart/form-data; boundary=\(multiFormBoundary)", forHTTPHeaderField: NGAHttpStrings.contentTypeHeaderField)
            task = defaultDataSession.uploadTaskWithRequest(request, fromData: data, completionHandler: finalBlock)
        }else{task = defaultDataSession.dataTaskWithRequest(request, completionHandler: finalBlock)}
        dataTaskUpdateBlock = progressBlock
        task.resume()
        return task
    }
    
    //MARK: Properties
    
    public lazy var defaultDataSession:NSURLSession = {
        let urlSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlSession = NSURLSession(configuration: urlSessionConfig, delegate: self, delegateQueue: nil)
        return urlSession
    }()
    
    public var multiFormBoundary = "4737809831466499882746641449"
    public var mutableDataTaskData:NSMutableData?
    public var dataTaskURLResponse:NSURLResponse?
    public var dataTaskError:NSError?
    public var dataTaskCompletionBlock:NetworkResponseBlock?
    public var dataTaskUpdateBlock:DataProgressBlock?
    
    public var trustedHosts:[String] = []
    
    //MARK: Session delegate
    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {print("session became invalid with error \(error)")}
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        var trusted = false
        for host in trustedHosts {if challenge.protectionSpace.host.containsString(host, caseInsensitive: true) {trusted = true;break}}
        let disposition = trusted ? NSURLSessionAuthChallengeDisposition.UseCredential : NSURLSessionAuthChallengeDisposition.PerformDefaultHandling
        let credential = trusted && challenge.protectionSpace.serverTrust != nil ? NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)  : challenge.proposedCredential
        completionHandler(disposition, credential)
    }
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {print("session did finish background")}
    
    //MARK: Session Task Delegate
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("completed :: error = \(error?.description)")
        if let completionBlock = dataTaskCompletionBlock {
            completionBlock(mutableDataTaskData?.copy() as? NSData, dataTaskURLResponse, error)
        }
        mutableDataTaskData = nil
        dataTaskURLResponse = nil
        dataTaskUpdateBlock = nil
        session.resetWithCompletionHandler { }
    }
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {print("did receive auth challenge")}
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let size = Int(bytesSent) ; let expectedSize = Int(totalBytesExpectedToSend)
        let mainBlock:VoidBlock = {
            self.dataTaskUpdateBlock?(size, expectedSize, task)
        }
        dispatch_async(dispatch_get_main_queue(), mainBlock)
    }
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {print("url session needs new body stream")}
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        print("url session is redirecting")
    }
    
    //MARK: Session Download delegate
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {print("finished download!")}
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {print("resumed at offset")}
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Wrote data!")
        let size = Int(bytesWritten) ; let expectedSize = Int(totalBytesExpectedToWrite)
        let mainBlock:VoidBlock = {
            self.dataTaskUpdateBlock?(size, expectedSize, downloadTask)
        }
        dispatch_async(dispatch_get_main_queue(), mainBlock)
    }
    
    //MARK: Session Data delegate
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {print("became download task")}
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if mutableDataTaskData == nil {mutableDataTaskData = NSMutableData()}
        mutableDataTaskData?.appendData(data)
        if let block = dataTaskUpdateBlock {
            let size = data.length
            let mainBlock:VoidBlock = {
                block(size, -1, dataTask)
            }
            dispatch_async(dispatch_get_main_queue(), mainBlock)
        }
    }
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        dataTaskURLResponse = response
        let responseDisposition = NSURLSessionResponseDisposition.Allow
        completionHandler(responseDisposition)
    }
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        print("will cache response!")
        completionHandler(proposedResponse)
    }
    
    
}

public enum HTTPMethod:String {
    case POST
    case GET
    case DELETE
    case PATCH
    case PUT
}








