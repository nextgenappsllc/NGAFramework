//
//  APIHandler.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/17/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

open class APIHandler: NSObject, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    /**
     Adds values to the url string with the format key=value and url encodes the values.
     
     The key and value are interpolated into the string like "\(value)" so typically strings numbers and bools are best to use.
     The output is a string in the follwing format: "\(url)?\(k1)=\(v1)&(k2)=(v2)..."
     
     - Parameter url: The url to send the request to as a String.
     
     - Parameter parameters: A dictionary ([AnyHashable:Any]) containing the key value pairs to add.
     
     - Returns: A string containing the base url with the parameters added to it.
     */
    open class func urlStringWithParameters(_ url:String, parameters:SwiftDictionary?) -> String {
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
     
     For files, you want to add the data and filename in the dictionary as follows:
     
     ["file":fileData, "file-filename": "myFile.pdf", "otherFile": otherFileData, "otherFile-filename": "anotherOne.png"... etc]
     
     sends fileData with the name myFile.pdf and otherFileData with the name anotherOne.png
     
     - Parameter boundary: The boundary as a string. It should be a long alphanumeric string.
     
     - Parameter parameters: A dictionary ([AnyHashable:Any]) containing the key value pairs to add.
     
     - Returns: The multiform data comprised of the key value pairs in the dictionary.
     */
    open class func createMultiFormData(_ boundary:String, parameters:SwiftDictionary?) -> Data? {
        guard var params = parameters else {return nil}
        let startSeperator = "--\(boundary)\r\n"
        let endSeperator = "--\(boundary)--\r\n"
        let body = NSMutableData()
        let fileNames = params.mapToNewDictionary(){(key, value) -> Any? in return parameters?["\(key)-filename"]}
        for key in Array(fileNames.keys) { params["\(key)-filename"] = nil }
        func appendStringToData(_ str:String?) {
            if let d = str?.data(using: String.Encoding.utf8, allowLossyConversion: true) {body.append(d)}
        }
        for (key, value) in params {
            appendStringToData(startSeperator)
            let fileName = fileNames.stringForKey(key) ?? key as? String
            var contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\""
            contentDispositionString += value is Data ? "; filename=\"\(fileName)\"\r\n" : "\r\n"
            appendStringToData(contentDispositionString)
            let contentTypeString = value is Data ? "Content-Type: application/octet-stream\r\n\r\n" : "Content-Type: text/plain\r\n\r\n"
            appendStringToData(contentTypeString)
            if let d = value as? Data { body.append(d) } else { appendStringToData("\(value)")}
            appendStringToData("\r\n")
        }
        if params.count > 0 {appendStringToData(endSeperator)}
        return body.copy() as? Data
    }

    /**
     Sends a http request to the specified url string with the entered parameters.
     
     The bare minimum required is the url string.
     
     - Parameter url: A string of where to send the request.
     
     - Parameter method: A HTTPMethod that you would like to use (GET, PUSH, PUT, etc.). Default is GET.
     
     - Parameter urlParamters: A dictionary containing paramters you wish to be added to the url. Default is nil.
     
     - Parameter multiFormParameters: A dictionary containing paramters you wish to be added to form for PUT, PATCH, or POST.
     
     - Parameter headerFields: A dictionary containing the header field as the key and the desired value.
     
     - Parameter progressBlock: A block that will be passed the progress of the download or upload. Default is nil.
     
     - Parameter completionBlock: A block that will be passed the result of the request upon completion.
     */
    @discardableResult open func sendRequestTo(_ url:String, method:HTTPMethod = .GET, urlParameters:SwiftDictionary? = nil, multiFormParameters:SwiftDictionary? = nil, headerFields:[String:String]? = nil, progressBlock:DataProgressBlock? = nil, completionBlock:NetworkResponseBlock?) -> URLSessionTask? {
        let urlString = type(of: self).urlStringWithParameters(url, parameters: urlParameters)
        guard var request = urlString.url?.toRequest() else {return nil}
        request.httpMethod = method.rawValue
        if let h = headerFields{for (k,v) in h{request.setValue(v, forHTTPHeaderField: k)}}
        let nullBlock:NetworkResponseBlock = {(d,r,e) in }
        let finalBlock = completionBlock ?? nullBlock
        let task:URLSessionTask
        if let data = type(of: self).createMultiFormData(multiFormBoundary, parameters: multiFormParameters) {
            request.setValue("multipart/form-data; boundary=\(multiFormBoundary)", forHTTPHeaderField: HTTPHeaderField.ContentType.rawValue)
            request.setValue(data.count.toString(), forHTTPHeaderField: HTTPHeaderField.ContentLength.rawValue)
            task = defaultDataSession.uploadTask(with: request, from: data, completionHandler: finalBlock)
        }else{
            if progressBlock == nil {task = defaultDataSession.dataTask(with: request, completionHandler: finalBlock)} else {
                task = defaultDataSession.dataTask(with: request)
                dataTaskUpdateBlock = progressBlock
                dataTaskCompletionBlock = completionBlock
            }
            
        }
        dataTaskUpdateBlock = progressBlock
        task.resume()
        return task
    }
    
    //MARK: Properties
    
    /**
     A NSURLSession object with the default session configuration with the delegate set to the APIHandler object.
     */
    open lazy var defaultDataSession:Foundation.URLSession = {
        let urlSessionConfig = URLSessionConfiguration.default
        let urlSession = Foundation.URLSession(configuration: urlSessionConfig, delegate: self, delegateQueue: nil)
        return urlSession
    }()
    
    /**
     A string to be used in the multiform as a boundary. It should be a long random number.
     */
    open var multiFormBoundary = "4737809831466499882746641449"
    open var mutableDataTaskData:NSMutableData?
    open var dataTaskURLResponse:URLResponse?
    open var dataTaskError:NSError?
    open var dataTaskCompletionBlock:NetworkResponseBlock?
    open var dataTaskUpdateBlock:DataProgressBlock?
    
    /**
     An array of trusted domain strings here to automatically trust hosts during authentication challanges.
     */
    open var trustedHosts:[String] = []
    
    //MARK: Session delegate
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {print("session became invalid with error \(error)")}
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var trusted = false
        for host in trustedHosts {if challenge.protectionSpace.host.containsString(host, caseInsensitive: true) {trusted = true;break}}
        let disposition = trusted ? Foundation.URLSession.AuthChallengeDisposition.useCredential : Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling
        let credential = trusted && challenge.protectionSpace.serverTrust != nil ? URLCredential(trust: challenge.protectionSpace.serverTrust!)  : challenge.proposedCredential
        completionHandler(disposition, credential)
    }
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {print("session did finish background")}
    
    //MARK: Session Task Delegate
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed :: error = \(error)")
        if let completionBlock = dataTaskCompletionBlock {
            completionBlock(mutableDataTaskData?.copy() as? Data, dataTaskURLResponse, error)
        }
        mutableDataTaskData = nil
        dataTaskURLResponse = nil
        dataTaskUpdateBlock = nil
        session.reset { }
    }
    open func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
//    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(URLSession.AuthChallengeDisposition, URLCredential?) -> Void)  {print("did receive auth challenge")}
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let size = Int(bytesSent) ; let expectedSize = Int(totalBytesExpectedToSend)
        let mainBlock:VoidBlock = {
            self.dataTaskUpdateBlock?(size, expectedSize, task)
        }
        DispatchQueue.main.async(execute: mainBlock)
    }
    open func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {print("url session needs new body stream")}
    open func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("url session is redirecting")
    }
    
    //MARK: Session Download delegate
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {print("finished download!")}
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {print("resumed at offset")}
    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Wrote data!")
        let size = Int(bytesWritten) ; let expectedSize = Int(totalBytesExpectedToWrite)
        let mainBlock:VoidBlock = {
            self.dataTaskUpdateBlock?(size, expectedSize, downloadTask)
        }
        DispatchQueue.main.async(execute: mainBlock)
    }
    
    //MARK: Session Data delegate
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {print("became download task")}
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if mutableDataTaskData == nil {mutableDataTaskData = NSMutableData()}
        mutableDataTaskData?.append(data)
        if let block = dataTaskUpdateBlock {
            let size = data.count
            let mainBlock:VoidBlock = {
                block(size, -1, dataTask)
            }
            DispatchQueue.main.async(execute: mainBlock)
        }
    }
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dataTaskURLResponse = response
        let responseDisposition = Foundation.URLSession.ResponseDisposition.allow
        completionHandler(responseDisposition)
    }
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
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


public enum HTTPContentType:String {
    case WWWFormUrlEncoded = "application/x-www-form-urlencoded"
    case JSON = "application/json"
    case OctetStream = "application/octet-stream"
    case TextPlain = "text/plain"
    case MultiPartFormData = "multipart/form-data"     //// needs ; boundary=() after it
    
}

public enum HTTPHeaderField:String {
    case ContentType = "Content-Type"
    case ContentLength = "Content-Length"
}

//struct NGAHttpStrings {
//    static let postMethod = "POST"
//    static let getMethod = "GET"
//    static let deleteMethod = "DELETE"
//    static let contentLengthHeaderField = "Content-Length"
//    static let contentTypeHeaderField = "Content-Type"
//    static let contentTypeWWWFormUrlEncoded = "application/x-www-form-urlencoded"
//}





