//
//  NGAWebViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 4/1/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import WebKit

open class NGAWKWebViewController: NGAViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    open var bannedDomains:[String] = []
    open var optionalDomains:[String] = []
    
    open var blockOptionalDomains = false
    
    open var cacheHTML:Bool {get{return webView.cacheHTML} set{webView.cacheHTML = newValue}}
    
    open var urlRequest:URLRequest? {
        didSet {
            if urlRequest != nil {
                let _=self.webView.load(urlRequest!)
            }
        }
    }
    
    
    open lazy var backButton:UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonPressed))
        return temp
    }()
    
    
    open lazy var webView:NGAWKWebView = {
        var configuration = WKWebViewConfiguration()
        //        self.addJQueryMobileScriptToContentController(configuration.userContentController)
        
        //        let temp = WKWebView(frame: CGRectZero, configuration: configuration)
        let temp = NGAWKWebView(frame: CGRect.zero, configuration: configuration)
        
        temp.navigationDelegate = self
        temp.uiDelegate = self
        temp.backgroundColor = UIColor.white
        return temp
    }()
    
    open var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.isScrollEnabled = false
        //        println("webVC view loaded")
        self.contentView.backgroundColor = UIColor.white
        
        if !cacheHTML || webView.htmlStringForURL(urlRequest?.url) == nil {
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
    

    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        println("webVC view will disappear")
        self.webView.stopLoading()
    }
    

    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        self.webView.frame = self.contentView.bounds
        //        self.webView.placeViewInView(view: self.contentView, andPosition: NGARelativeViewPosition.AboveTop)
    }
    
    //MARK: WKWebView
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("finished", navigation)
        //        if let url = webView.URL {
        //            var lastPathComponent = url.lastPathComponent
        //            var host = url.host
        //        }
        
        
        if !webView.isDescendant(of: self.contentView) {
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
    
    
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        var decision = WKNavigationActionPolicy.allow
        
        let url = navigationAction.request.url
        let banned = self.isURLBanned(url!)
        if banned {
            print("BANNED::: \(String(describing: url?.absoluteString))")
            decision = WKNavigationActionPolicy.cancel
        }
        else {
            
            
        }
        
        
        decisionHandler(decision)
        
        
    }
    
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let decision = WKNavigationResponsePolicy.allow
        decisionHandler(decision)
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        println("Start provisional nav \(navigation.description)")
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("JAVA ALERT PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("JAVA CONFIRM PANEL MESSAGE " + message + "by frame" + frame.description)
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("JAVA TEXT INPUT PANEL MESSAGE " + prompt + "by frame" + frame.description)
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("executing: " + message.name)
    }
    
    
    //MARK: Actions
    @objc open func backButtonPressed(){
        self.webView.goBack()
    }
    
    //MARK: Helper Methods
    
    open func runScriptFrom(_ resource:String, andExtension scriptExtension:String) {
        //        println(resource)
        //        var scriptError:NSError? = nil
        let scriptUrl = Bundle.main.url(forResource: resource, withExtension: scriptExtension)
        if scriptUrl != nil {
            var hideTableOfContentScriptString: NSString?
            do {
                hideTableOfContentScriptString = try NSString(contentsOf: scriptUrl!, encoding: String.Encoding.utf8.rawValue)
            } catch {
                //                scriptError = error
                hideTableOfContentScriptString = nil
            }
            if hideTableOfContentScriptString != nil {
                webView.evaluateJavaScript(hideTableOfContentScriptString! as String, completionHandler: { (result:Any?, error:Error?) -> Void in
                    if error != nil {
                        print("js error \(String(describing: error))")
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
    
    
    open func isURLBanned(_ url:URL) -> Bool {
        var banned = false
        let urlString = url.absoluteString
        for bannedDomain in bannedDomains {
            let range = urlString.range(of: bannedDomain, options: NSString.CompareOptions.caseInsensitive)
            if range != nil {
                banned = true
                break
            }
        }
        if self.blockOptionalDomains && !banned {
            for optionalDomain in optionalDomains {
                let range = urlString.range(of: optionalDomain, options: NSString.CompareOptions.caseInsensitive)
                if range != nil {
                    banned = true
                    break
                }
            }
        }
        
        return banned
    }
    
    
    
}




open class NGAWKWebView: WKWebView {
    
    open var cacheHTML = false
    open var apiHandler = CachedWebViewApiHandler()
    open var htmlCacheDirectory:String {get{return tempSubDirectoryWithName("NGAHTMLCache")}}
    
    open override func load(_ request: URLRequest) -> WKNavigation? {
        if cacheHTML  {
            let url = request.url
            if let s = self.htmlStringForURL(url) {
                self.loadHTMLString(s, baseURL: url?.baseURL)
            }
            let task:URLSessionTask
            if let body = request.httpBody {
                task = apiHandler.defaultDataSession.uploadTask(with: request, from: body, completionHandler: { (data:Data?, urlResponse:URLResponse?, error:Error?) -> Void in
                    guard let s = self.htmlStringForURL(url) , self.saveHTMLData(data, fromUrlPath: url?.absoluteString) else {return}
                    self.loadHTMLString(s, baseURL: url?.baseURL)
                })
            }else if request.httpBodyStream != nil {
                task = apiHandler.defaultDataSession.uploadTask(withStreamedRequest: request)
                let _=apiHandler.streamDictionary.append(task, value: request.httpBodyStream)
            }else {
                task = apiHandler.defaultDataSession.dataTask(with: request, completionHandler: { (data:Data?, urlResponse:URLResponse?, error:Error?) -> Void in
                    guard self.saveHTMLData(data, fromUrlPath: url?.absoluteString), let s = self.htmlStringForURL(url) else {return}
                    self.loadHTMLString(s, baseURL: url?.baseURL)
                })
            }
            task.resume()
            return nil
        } else {return super.load(request)}
    }
    
    open func htmlStringForURL(_ url:URL?) -> String? {
        guard let url = htmlCacheDirectory.stringByAddingPathComponent(url?.absoluteString.crc32CheckSum())?.appendIfNotNil(".html").fileUrl else {return nil}
        return (try? Data(contentsOf: url))?.toString()
    }
    
    open func saveHTMLData(_ htmlData:Data?, fromUrlPath path:String?) -> Bool {
        print(htmlData != nil, String.isNotEmpty(path))
        guard htmlData != nil && String.isNotEmpty(path),
            let url = htmlCacheDirectory.stringByAddingPathComponent(path!.crc32CheckSum())?.appendIfNotNil(".html").fileUrl , htmlData != (try? Data(contentsOf: url))
            else {return false}
        ((try? htmlData?.write(to: url, options: [.atomic])) as ()??)
        return true
    }
    
    open func tempSubDirectoryWithName(_ name:String?) -> String {
        let temp = NSTemporaryDirectory()
        guard String.isNotEmpty(name), let path = temp.stringByAddingPathComponent(name) else {return temp}
        if !FileManager.default.fileExists(atPath: path) {_ = try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)}
        return path
    }
    
}





open class CachedWebViewApiHandler:APIHandler {
    var streamDictionary:[URLSessionTask:InputStream] = [:]

    open override func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        completionHandler(streamDictionary[task])
    }
//    open override func urlSession(_ session: Foundation.URLSession, task: URLSessionTask, needNewBodyStream completionHandler: (InputStream?) -> Void) {
//        completionHandler(streamDictionary[task])
//    }
}




