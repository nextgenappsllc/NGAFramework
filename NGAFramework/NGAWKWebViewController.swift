//
//  NGAWebViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 4/1/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import WebKit

class NGAWKWebViewController: NGAViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    var bannedDomains:[String] = []
    var optionalDomains:[String] = []
    
    var blockOptionalDomains = false
    
    var cacheHTML:Bool {get{return webView.cacheHTML} set{webView.cacheHTML = newValue}}
    let apiHandler = NGAAPIHandler()
    
    var urlRequest:NSURLRequest? {
        didSet {
            if urlRequest != nil {
                self.webView.loadRequest(urlRequest!)
                
//                if !cacheHTML {
//                    self.webView.loadRequest(urlRequest!)
//                } else {
//                    if let s = self.htmlStringForURL(self.urlRequest?.URL) {
//                        self.webView.loadHTMLString(s, baseURL: self.urlRequest?.URL)
//                        self.contentView.addSubviewIfNeeded(self.webView)
//                        self.contentView.bringSubviewToFront(self.webView)
//                    }
//                    apiHandler.getRequestToURL(urlRequest?.URL, andCompletionBlock: { (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) -> Void in
//                        let saved = self.saveHTMLData(data, fromUrlPath: self.urlRequest?.URL?.absoluteString)
//                        if !saved {return}
//                        if let s = self.htmlStringForURL(self.urlRequest?.URL) {
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                self.webView.loadHTMLString(s, baseURL: self.urlRequest?.URL)
//                                self.contentView.addSubviewIfNeeded(self.webView)
//                                self.contentView.bringSubviewToFront(self.webView)
//                            })
//                            
//                        }
//                    })
//                }
            }
        }
    }
    
    
    lazy var backButton:UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed")
        return temp
    }()
    
    
    lazy var webView:NGAWKWebView = {
        var configuration = WKWebViewConfiguration()
        //        self.addJQueryMobileScriptToContentController(configuration.userContentController)
        
        //        let temp = WKWebView(frame: CGRectZero, configuration: configuration)
        let temp = NGAWKWebView(frame: CGRectZero, configuration: configuration)
        
        temp.navigationDelegate = self
        temp.UIDelegate = self
        temp.backgroundColor = UIColor.whiteColor()
        return temp
    }()
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        println("webVC view will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        println("webVC view did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //        println("webVC view will disappear")
        self.webView.stopLoading()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //        println("webVC view did disappear")
        //        self.webView.stopLoading()
        
        
    }
    
    override func setFramesForSubviews() {
        super.setFramesForSubviews()
        self.webView.frame = self.contentView.bounds
        //        self.webView.placeViewInView(view: self.contentView, andPosition: NGARelativeViewPosition.AboveTop)
    }
    
    //MARK: WKWebView
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
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
    
    
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
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
    
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        let decision = WKNavigationResponsePolicy.Allow
        decisionHandler(decision)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        println("Start provisional nav \(navigation.description)")
    }
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        print("JAVA ALERT PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        print("JAVA CONFIRM PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        print("JAVA TEXT INPUT PANEL MESSAGE " + prompt + "by frame" + frame.description)
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("executing: " + message.name)
    }
    
    
    //MARK: Actions
    func backButtonPressed(){
        self.webView.goBack()
    }
    
    //MARK: Helper Methods
    
    func runScriptFrom(resource:String, andExtension scriptExtension:String) {
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
    
    
//    func getViewFrame() -> CGRect{
//        var viewFrame = view.frame
//        if navigationController != nil {
//            let navBarFrame = navigationController!.navigationBar.frame
//            viewFrame.origin.y = navBarFrame.origin.y + navBarFrame.size.height
//            viewFrame.size.height = viewFrame.size.height - viewFrame.origin.y
//        }
//        if tabBarController != nil {
//            let tabBarFrame = tabBarController!.tabBar.frame
//            viewFrame.size.height = tabBarFrame.origin.y - viewFrame.origin.y
//        }
//        
//        
//        
//        return viewFrame
//    }
    
    func isURLBanned(url:NSURL) -> Bool {
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
    
    
    var htmlCacheDirectory:String {get{return tempSubDirectoryWithName("NGAHTMLCache")}}
    
    func htmlStringForURL(url:NSURL?) -> String? {
        if let path = url?.absoluteString {
            if let rPath = htmlCacheDirectory.stringByAddingPathComponent(NSString.hashStringFromString(path)) {
                let localUrl = NSURL(fileURLWithPath: rPath + ".html")
                if let data = NSData(contentsOfURL: localUrl) {
                    return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
                }
            }
            
        }
        return nil
    }
    
    func saveHTMLString(html:String?, fromUrlPath path:String?, completionBlock:VoidBlock?) {
        
        if let p = path {
            if let rPath = htmlCacheDirectory.stringByAddingPathComponent(NSString.hashStringFromString(p)) {
                let url = NSURL(fileURLWithPath: rPath + ".html")
                if let data = html?.dataUsingEncoding(NSUTF8StringEncoding) {
                    data.writeToURL(url, atomically: true)
                } else {
                    
                }
            }
        }
        completionBlock?()
        
    }
    
    func saveHTMLData(htmlData:NSData?, fromUrlPath path:String?) -> Bool {
        
        if let p = path {
            if let rPath = htmlCacheDirectory.stringByAddingPathComponent(NSString.hashStringFromString(p)) {
                let url = NSURL(fileURLWithPath: rPath + ".html")
                if htmlData != nil && htmlData != NSData(contentsOfURL: url) {
                    htmlData?.writeToURL(url, atomically: true)
                    return true
                }
                
            }
        }
        return false
        
    }
    
    
    
    
    func tempSubDirectoryWithName(name:String?) -> String {
        var temp = NSTemporaryDirectory()
        if let cName = name {
            temp = temp.stringByAddingPathComponent(cName) ?? temp
            let directoryExists = NSFileManager.defaultManager().fileExistsAtPath(temp)
            if !directoryExists {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(temp, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    //                        error = error1
                }
            }
        }
        //        println(temp)
        return temp
    }
    
    
}




class NGAWKWebView: WKWebView {
    
    var cacheHTML = false
    var apiHandler = NGAAPIHandler()
    var htmlCacheDirectory:String {get{return tempSubDirectoryWithName("NGAHTMLCache")}}
    
    override func loadRequest(request: NSURLRequest) -> WKNavigation? {
        if cacheHTML  {
            let url = request.URL
            if let s = self.htmlStringForURL(url) {
                self.loadHTMLString(s, baseURL: url?.baseURL)
            }
            apiHandler.getRequestToURL(url, andCompletionBlock: { (data:NSData?, urlResponse:NSURLResponse?, error:NSError?) -> Void in
                let saved = self.saveHTMLData(data, fromUrlPath: url?.absoluteString)
                if !saved {return}
                if let s = self.htmlStringForURL(url) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadHTMLString(s, baseURL: url?.baseURL)
                    })
                    
                }
            })
            return nil
        } else {return super.loadRequest(request)}
    }
    
    func htmlStringForURL(url:NSURL?) -> String? {
        if let path = url?.absoluteString {
            if let rPath = htmlCacheDirectory.stringByAddingPathComponent(NSString.hashStringFromString(path)) {
                let localUrl = NSURL(fileURLWithPath: rPath + ".html")
                if let data = NSData(contentsOfURL: localUrl) {
                    return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
                }
            }
            
        }
        return nil
    }
    
    func saveHTMLData(htmlData:NSData?, fromUrlPath path:String?) -> Bool {
        
        if let p = path {
            if let rPath = htmlCacheDirectory.stringByAddingPathComponent(NSString.hashStringFromString(p)) {
                let url = NSURL(fileURLWithPath: rPath + ".html")
                if htmlData != nil && htmlData != NSData(contentsOfURL: url) {
                    htmlData?.writeToURL(url, atomically: true)
                    return true
                }
                
            }
        }
        return false
        
    }
    
    
    
    
    func tempSubDirectoryWithName(name:String?) -> String {
        var temp = NSTemporaryDirectory()
        if let cName = name {
            temp = temp.stringByAddingPathComponent(cName) ?? temp
            let directoryExists = NSFileManager.defaultManager().fileExistsAtPath(temp)
            if !directoryExists {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(temp, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    //                        error = error1
                }
            }
        }
        //        println(temp)
        return temp
    }
    
}










