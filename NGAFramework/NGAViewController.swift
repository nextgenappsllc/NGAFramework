//
//  ViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import UIKit

public class NGAViewController: UIViewController {

    //MARK: Properties
    public weak var customNavigationController:NGANavigationController?
    
    public weak var customNavigationItem:NGANavigationItem? {
        get {
            return self.customNavigationController?.customNavigationItemFor(self)
        }
    }
    
    public var adjustsForStatusBar:Bool = true {didSet{setContentViewFrame()}}
    
    //adding bool to see whether to adjust the contenview frame for keyboard or not
    public var adjustsForKeyboard = false {didSet{dispatch_async(dispatch_get_main_queue()) {self.setupAdjustsForKeyboard(self.adjustsForKeyboard)}}}
    
    public func setupAdjustsForKeyboard(newValue:Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        if newValue {
            notificationCenter.addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: Selector("keyboardDidHide:"), name: UIKeyboardWillHideNotification, object: nil)
        } else {
            notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
//    func keyboardDidShow(notification:NSNotification?) {
////        print("showing keyboard")
//        if let kbFrame = getKeyboardRectFromNotification(notification) {
//            if let r = currentFirstResponder() {
//                let rFrame = r.frame
//                var aRect = contentView.frame
//                aRect.size.height -= kbFrame.height
//                let bRect = contentView.convertRect(rFrame, fromView: r.superview)
//                if !CGRectContainsRect(aRect, bRect) {
//                    contentView.top = contentViewFrame.origin.y + aRect.size.height - (bRect.origin.y + bRect.size.height)
//                }
//            }
//        }
//    }
    
    public func keyboardDidShow(notification:NSNotification?) {
        if !viewIsCurrentlyDisplayed {return}
        if let kbFrame = getKeyboardRectFromNotification(notification) {
            if let r = currentFirstResponder() {
                if !r.isDescendantOfView(contentView) {return}
                let rFrame = r.frame
                if let delegate = UIApplication.sharedApplication().delegate {
                    if let window = delegate.window {
                        if let w = window {
                            let absoluteRect = w.convertRect(rFrame, fromView: r.superview)
                            let diff = (w.frameHeight - kbFrame.height) - (absoluteRect.origin.y + absoluteRect.height)
                            if diff < 0 {
                                contentView.top = contentViewFrame.origin.y + diff
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func keyboardDidHide(notification:NSNotification?) {
        setContentViewFrame()
    }
    
//    var yShift:CGFloat = 0 {didSet{contentView.top = contentViewFrame.origin.y + yShift}}
    
    
    
    private func getKeyboardRectFromNotification(notification:NSNotification?, beginFrame:Bool = false) -> CGRect? {
        let key = beginFrame ? UIKeyboardFrameBeginUserInfoKey : UIKeyboardFrameEndUserInfoKey
        return (notification?.userInfo?[key] as? NSValue)?.CGRectValue()
    }
    
    private func getKeyboardResponderFrame() -> CGRect? {
        
        return currentFirstResponder()?.frame
    }
    
    private func currentFirstResponder() -> UIView? {
        func firstResponderForSubviews(subviews:[UIView]) -> UIView? {
//            for object in firstResponders {if object.isFirstResponder() {return object as? UIView}}
            var temp:UIView?
            autoreleasepool {for v in subviews {if v.isFirstResponder() {temp = v; break} else if let responder = firstResponderForSubviews(v.subviews) {temp = responder; break}}}
            return temp
        }
        return firstResponderForSubviews(view.subviews)
    }
    
    
    
    public var firstResponders = NSArray()
    
    public var hasFirstResponders:Bool {
        get {
            var temp = false
            for object in self.firstResponders {
                if object.isFirstResponder() {
                    temp = true
                    break
                }
            }
//            println(temp)
            return temp
        }
    }
    
    public lazy var contentView:NGAContentView = {
        var temp = NGAContentView()
        temp.contentViewDelegate = self
        return temp
    }()
    
    public var contentViewFrame:CGRect {
        get {
            let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
            let viewBounds = self.view.bounds
            var heightAdjustment:CGFloat = 0
            var temp = viewBounds
            
            if self.customNavigationController != nil {
                
            }
            else {
                if self.navigationController != nil {
                    let navBarFrame = self.navigationController!.navigationBar.frame
                    if self.navigationController!.navigationBar.translucent {
                        temp.origin.y = navBarFrame.origin.y + navBarFrame.size.height
                    }
//                    else if navBarFrame.size.height + navBarFrame.origin.y <= 0{
//                        temp.origin.y = statusBarFrame.size.height
//                    }
                }
                else {
                    temp.origin.y = adjustsForStatusBar ? statusBarFrame.size.height : 0
                }
                
                
                if self.tabBarController != nil {
                    if self.tabBarController!.tabBar.translucent {
                        let tabBarFrame = self.tabBarController!.tabBar.frame
                        heightAdjustment = tabBarFrame.size.height
                        //                            println("height adjustment \(heightAdjustment)")
                    }
                }
            }
            
            temp.size.height = viewBounds.size.height - temp.origin.y - heightAdjustment
            
//            println("content frame \(temp)")
            
            return temp
        }
        
    }
    
    public var viewIsCurrentlyDisplayed:Bool {
        get {
            var temp = false
            if self.isViewLoaded() && self.view.window != nil {
                temp = true
            }
            return temp
        }
    }
    
    public var landscape:Bool {
        get {
            var temp = false
            
            if self.view.bounds.size.width > self.view.bounds.size.height {
                temp = true
            }
            
            return temp
        }
    }
    
    //MARK: View Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        onInit()
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.init()
    }
    
    public override func loadView() {
        super.loadView()
        onLoad()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setContentViewFrame()
        self.view.addSubview(self.contentView)
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupAdjustsForKeyboard(adjustsForKeyboard)
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        setupAdjustsForKeyboard(false)
        
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    
    //MARK: Memory Warning
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    
    
    
    //MARK: Setup
    
    public func onInit() {
        
    }
    
    public func onLoad() {
        
    }
    
    public func setup(){
        
    }
    
    //MARK: Frames
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        println("will layout subviews")
//        println("view frame \(self.view.frame) and bounds \(self.view.bounds)")
        self.setContentViewFrame()
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        println("did layout subviews")
        //TESTING
        self.setContentViewFrame()
    }
    
    public func setContentViewFrame() {
        let newContentViewFrame = self.contentViewFrame
//        var updateSubViews = false
//        
//        if self.contentView.frame.size != newContentViewFrame.size {
//            updateSubViews = true
//        }
        
        let updateSubViews = self.contentView.frame.size != newContentViewFrame.size
        
        self.contentView.frame = self.contentViewFrame
        
        
//        self.setFramesForSubviews()
        if updateSubViews {
            self.setFramesForSubviews()
        }
    }
    
    public func setFramesForSubviews() {
//        println("set frames for subviews")
        
    }
    
    //MARK: Transition 
    
    public override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let block:VoidBlock = {
            self.presentingViewController
            if let presenter = self.tabBarController ?? self.navigationController ?? self.customNavigationController {
                presenter.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
            } else {super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)}
            
        }
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    public func pushToViewController(viewController:UIViewController, with startFrame:CGRect?) {
        
        if startFrame != nil && viewController is NGAViewController && self.customNavigationController != nil {
            self.customNavigationController?.pushToViewController(viewController as! NGAViewController, with: startFrame!)
        }
        else {
            self.pushToViewController(viewController)
        }
    }
    
    public func pushToViewController(viewController:UIViewController, animated:Bool = true) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if viewController is NGAViewController && self.customNavigationController != nil {
                self.customNavigationController?.pushToViewController(viewController as! NGAViewController)
            }
            else {
                self.navigationController?.pushViewController(viewController, animated: animated)
            }
        }
        
    }
    
    public func popViewController() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if self.customNavigationController != nil {
                self.customNavigationController?.popViewController()
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    public func resignAllFirstResponders() {
        for object in self.firstResponders {
            object.resignFirstResponder()
        }
        
    }
    
    public func addResponderToFirstResponders(object:UIResponder?) {
        if let nonNilObject: UIResponder = object {
            if !self.firstResponders.containsObject(nonNilObject) {
                let tempArray = self.firstResponders.mutableCopy() as! NSMutableArray
                tempArray.addObject(nonNilObject)
                self.firstResponders = tempArray.copy() as! NSArray
            }
            
            
        }
    }
    
    public func removeResponderFromFirstResponders(object:UIResponder?) {
        if let nonNilObject:UIResponder = object {
            if self.firstResponders.containsObject(nonNilObject) {
                let tempArray = self.firstResponders.mutableCopy() as! NSMutableArray
                tempArray.removeObject(nonNilObject)
                self.firstResponders = tempArray.copy() as! NSArray
            }
        }
    }
    
    public func addRespondersToFirstResponders(objects:NSArray?) {
        if let responders:NSArray = objects {
            for responder in responders {
                self.addResponderToFirstResponders(responder as? UIResponder)
            }
        }
    }
    
    public func removeRespondersToFirstResponders(objects:NSArray?) {
        if let responders:NSArray = objects {
            for responder in responders {
                self.removeResponderFromFirstResponders(responder as? UIResponder)
            }
        }
    }
    
    
    //MARK: Pop up
    public func flash(title title:String?, message:String?, cancelTitle:String?, actions:UIAlertAction?...) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelBlock:AlertActionBlock = {(action:UIAlertAction!) -> Void in }
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel, handler: cancelBlock)
            alertController.addAction(cancelAction)
            for action in actions {
                if let a = action {alertController.addAction(a)}
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}





public class NGAContentView: UIScrollView, UIGestureRecognizerDelegate {
    
    public weak var contentViewDelegate:NGAViewController?
    
    public var willDynamicallyAdjustBottomBounds:Bool = false {
        didSet {
            self.dynamicallyAdjustBottomBounds()
        }
    }
    
    public var resignFirstResponderOnTap = true
    public var resignFirstResponderOnBoundsChange = true
    
    public lazy var tapRecognizer:UITapGestureRecognizer = {
        var temp = UITapGestureRecognizer(target: self, action: "userTapped")
        temp.delegate = self
        return temp
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapRecognizer)
//        tapRecognizer.cancelsTouchesInView = false
    }

//    override init() {
////        super.init()
//        
////        self.addGestureRecognizer(tapRecognizer)
//        super.init(frame: CGRectZero)
//    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        
    }
    
    public override var backgroundColor:UIColor? {
        didSet {
            if self.backgroundColor != oldValue {
                self.contentViewDelegate?.view.backgroundColor = self.backgroundColor
//                println("view color is \(self.contentViewDelegate?.view.backgroundColor)")
            }
        }
    }
    
    public override func addSubview(view: UIView) {
        super.addSubview(view)
        dynamicallyAdjustBottomBounds()
        
    }
    
    public override var frame:CGRect {
        didSet {

            dynamicallyAdjustBottomBounds()
            
        }
    }
    
    public override var bounds:CGRect {
        didSet {
            
            if self.scrollEnabled && self.resignFirstResponderOnBoundsChange {
                self.contentViewDelegate?.resignAllFirstResponders()
            }
//            println("bounds changed to \(bounds)")
            
        }
    }
    
    public func dynamicallyAdjustBottomBounds() {
        
        
        var newBounds = self.bounds
        
        if willDynamicallyAdjustBottomBounds {
            
            let bottom = self.frame.height
            var lowestPoint:CGFloat = 0
            
            for subview in self.subviews {

                let subviewBottom = subview.frame.origin.y + subview.frame.size.height
                
                //                    println("subview \(subview) has bottom of \(subviewBottom)")
                if subviewBottom > lowestPoint && subview.alpha > 0{
                    lowestPoint = subviewBottom
                }
            }
            
//            println("lowest point \(lowestPoint) > \(bottom) bottom = \(lowestPoint > bottom)")
            
            if lowestPoint > bottom {
                self.scrollEnabled = true
                newBounds.size.height = lowestPoint
            }
            else {
                self.scrollEnabled = false
                newBounds.size.height = bottom
            }
        }
        
        self.contentSize = newBounds.size
        
        
    }
    
    public func userTapped() {
        if self.resignFirstResponderOnTap {
            self.contentViewDelegate?.resignAllFirstResponders()
        }
        
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let simutaneousRecognition = true
//                println("gesture recognizer\(gestureRecognizer.description) and other recognizer \(otherGestureRecognizer.description)")
        return simutaneousRecognition
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        var receiveTouch = true
        
        if gestureRecognizer == self.tapRecognizer {
            receiveTouch = self.contentViewDelegate?.hasFirstResponders ?? true
        }
        
//        println("\(gestureRecognizer) will receive touch \(receiveTouch)\n")
        return receiveTouch
    }
    
    
    
    
}







