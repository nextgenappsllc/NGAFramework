//
//  NGAWebViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 4/1/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import WebKit

public class NGAWKWebViewController: NGAViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    public var bannedDomains:[String] = []
    public var optionalDomains:[String] = []
    
    public var blockOptionalDomains = false
    
    public var cacheHTML:Bool {get{return webView.cacheHTML} set{webView.cacheHTML = newValue}}
    
    public var urlRequest:NSURLRequest? {
        didSet {
            if urlRequest != nil {
                self.webView.loadRequest(urlRequest!)
            }
        }
    }
    
    
    public lazy var backButton:UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backButtonPressed))
        return temp
    }()
    
    
    public lazy var webView:NGAWKWebView = {
        var configuration = WKWebViewConfiguration()
        //        self.addJQueryMobileScriptToContentController(configuration.userContentController)
        
        //        let temp = WKWebView(frame: CGRectZero, configuration: configuration)
        let temp = NGAWKWebView(frame: CGRectZero, configuration: configuration)
        
        temp.navigationDelegate = self
        temp.UIDelegate = self
        temp.backgroundColor = UIColor.whiteColor()
        return temp
    }()
    
    public var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.scrollEnabled = false
        //        println("webVC view loaded")
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        if !cacheHTML || webView.htmlStringForURL(urlRequest?.URL) == nil {
            let loadingLabel = UILabel()
            loadingLabel.text = "Loading..."
            loadingLabel.font = UIFont(name: "Verdana-Bold", size: 20.0)
            loadingLabel.sizeToFit()
            var loadingLabelFrame = loadingLabel.frame
            loadingLabelFrame.origin.x = (self.contentView.frame.size.width - loadingLabelFrame.size.width) / 2
            loadingLabelFrame.origin.y = self.contentView.frame.size.height / 6
            loadingLabel.frame = loadingLabelFrame
            self.contentView.addSubview(loadingLabel)
            
            var activityIndicatorFrame = self.activityIndicator.frame
            activityIndicatorFrame.origin.x = (self.contentView.frame.size.width - activityIndicatorFrame.size.width) / 2
            activityIndicatorFrame.origin.y = loadingLabelFrame.origin.y + loadingLabelFrame.size.height + 10
            self.activityIndicator.frame = activityIndicatorFrame
            self.contentView.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
    }
    

    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //        println("webVC view will disappear")
        self.webView.stopLoading()
    }
    

    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        self.webView.frame = self.contentView.bounds
        //        self.webView.placeViewInView(view: self.contentView, andPosition: NGARelativeViewPosition.AboveTop)
    }
    
    //MARK: WKWebView
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finished", navigation)
        //        if let url = webView.URL {
        //            var lastPathComponent = url.lastPathComponent
        //            var host = url.host
        //        }
        
        
        if !webView.isDescendantOfView(self.contentView) {
            self.contentView.addSubview(webView)
            self.activityIndicator.stopAnimating()
        }
        if webView.canGoBack {
            self.navigationItem.rightBarButtonItem = self.backButton
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        var decision = WKNavigationActionPolicy.Allow
        
        let url = navigationAction.request.URL
        let banned = self.isURLBanned(url!)
        if banned {
            print("BANNED::: \(url?.absoluteString)")
            decision = WKNavigationActionPolicy.Cancel
        }
        else {
            
            
        }
        
        
        decisionHandler(decision)
        
        
    }
    
    
    public func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        let decision = WKNavigationResponsePolicy.Allow
        decisionHandler(decision)
    }
    
    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        println("Start provisional nav \(navigation.description)")
    }
    
    public func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        print("JAVA ALERT PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    public func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        print("JAVA CONFIRM PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    public func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        print("JAVA TEXT INPUT PANEL MESSAGE " + prompt + "by frame" + frame.description)
    }
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("executing: " + message.name)
    }
    
    
    //MARK: Actions
    public func backButtonPressed(){
        self.webView.goBack()
    }
    
    //MARK: Helper Methods
    
    public func runScriptFrom(resource:String, andExtension scriptExtension:String) {
        //        println(resource)
        //        var scriptError:NSError? = nil
        let scriptUrl = NSBundle.mainBundle().URLForResource(resource, withExtension: scriptExtension)
        if scriptUrl != nil {
            var hideTableOfContentScriptString: NSString?
            do {
                hideTableOfContentScriptString = try NSString(contentsOfURL: scriptUrl!, encoding: NSUTF8StringEncoding)
            } catch {
                //                scriptError = error
                hideTableOfContentScriptString = nil
            }
            if hideTableOfContentScriptString != nil {
                webView.evaluateJavaScript(hideTableOfContentScriptString! as String, completionHandler: { (result:AnyObject?, error:NSError?) -> Void in
                    if error != nil {
                        print("js error " + error!.description)
                    }
                    else {
                        print("no error")
                    }
                    
                })
            }
            else {
                print("user script string = nil")
            }
        }
        else {
            print("script url not found")
        }
        
    }
    
    
    public func isURLBanned(url:NSURL) -> Bool {
        var banned = false
        if let urlString:NSString = url.absoluteString {
            for bannedDomain in bannedDomains {
                let range = urlString.rangeOfString(bannedDomain, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if range.location != NSNotFound {
                    banned = true
                    break
                }
            }
            if self.blockOptionalDomains && !banned {
                for optionalDomain in optionalDomains {
                    let range = urlString.rangeOfString(optionalDomain, options: NSStringCompareOptions.CaseInsensitiveSearch)
                    if range.location != NSNotFound {
                        banned = true
                        break
                    }
                }
            }
        }
        
        return banned
    }
    
    
    
}




public class NGAWKWebView: WKWebView {
    
    public var cacheHTML = false
    public var apiHandler = CachedWebViewApiHandler()
    public var htmlCacheDirectory:String {get{return tempSubDirectoryWithName("NGAHTMLCache")}}
    
    public override func loadRequest(request: NSURLRequest) -> WKNavigation? {
        if cacheHTML  {
            let url = request.URL
            if let s = self.htmlStringForURL(url) {
                self.loadHTMLString(s, baseURL: url?.baseURL)
            }
            let task:NSURLSessionTask
            if let body = request.HTTPBody {
                task = apiHandler.defaultDataSession.uploadTaskWithRequest(request, fromData: body){ (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) -> Void in
                    guard let s = self.htmlStringForURL(url) where self.saveHTMLData(data, fromUrlPath: url?.absoluteString) else {return}
                    self.loadHTMLString(s, baseURL: url?.baseURL)
                }
            }else if request.HTTPBodyStream != nil {
                task = apiHandler.defaultDataSession.uploadTaskWithStreamedRequest(request)
                apiHandler.streamDictionary.append(task, value: request.HTTPBodyStream)
            }else {
                task = apiHandler.defaultDataSession.dataTaskWithRequest(request){ (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) -> Void in
                    guard self.saveHTMLData(data, fromUrlPath: url?.absoluteString), let s = self.htmlStringForURL(url) else {return}
                    self.loadHTMLString(s, baseURL: url?.baseURL)
                }
            }
            task.resume()
            return nil
        } else {return super.loadRequest(request)}
    }
    
    public func htmlStringForURL(url:NSURL?) -> String? {
        guard let url = htmlCacheDirectory.stringByAddingPathComponent(url?.absoluteString.crc32CheckSum())?.appendIfNotNil(".html").fileUrl else {return nil}
        return NSData(contentsOfURL: url)?.toString()
    }
    
    public func saveHTMLData(htmlData:NSData?, fromUrlPath path:String?) -> Bool {
        print(htmlData != nil, String.isNotEmpty(path))
        guard htmlData != nil && String.isNotEmpty(path),
            let url = htmlCacheDirectory.stringByAddingPathComponent(path!.crc32CheckSum())?.appendIfNotNil(".html").fileUrl where htmlData != NSData(contentsOfURL: url)
            else {return false}
        htmlData?.writeToURL(url, atomically: true)
        return true
    }
    
    public func tempSubDirectoryWithName(name:String?) -> String {
        let temp = NSTemporaryDirectory()
        guard String.isNotEmpty(name), let path = temp.stringByAddingPathComponent(name) else {return temp}
        if !NSFileManager.defaultManager().fileExistsAtPath(path) {_ = try? NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)}
        return path
    }
    
}





public class CachedWebViewApiHandler:APIHandler {
    var streamDictionary:[NSURLSessionTask:NSInputStream] = [:]
    public override func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        completionHandler(streamDictionary[task])
    }
}




