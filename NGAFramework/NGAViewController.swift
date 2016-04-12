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
    public var adjustsForStatusBar:Bool = true {didSet{if oldValue != adjustsForStatusBar { setContentViewFrame()}}}
    
    public var adjustsForKeyboard = false {
        didSet{
            if oldValue != adjustsForKeyboard {
                NGAExecute.performOnMainThread() {self.setupAdjustsForKeyboard(self.adjustsForKeyboard)}
            }
        }
    }
    
    public func setupAdjustsForKeyboard(newValue:Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        if newValue {
            notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        } else {
            notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    
    public func keyboardDidShow(notification:NSNotification?) {
        guard let kbFrame = getKeyboardRectFromNotification(notification), let r = currentFirstResponder(), let w = window where viewIsCurrentlyDisplayed else {return}
        if !r.isDescendantOfView(contentView) {return}
        let rFrame = r.frame
        let absoluteRect = w.convertRect(rFrame, fromView: r.superview)
        let diff = (w.frameHeight - kbFrame.height) - (absoluteRect.origin.y + absoluteRect.height)
        if diff < 0 {contentView.top = contentViewFrame.origin.y + diff}
    }
    
    public func keyboardDidHide(notification:NSNotification?) {setContentViewFrame()}
    
    private func getKeyboardRectFromNotification(notification:NSNotification?, beginFrame:Bool = false) -> CGRect? {
        let key = beginFrame ? UIKeyboardFrameBeginUserInfoKey : UIKeyboardFrameEndUserInfoKey
        return (notification?.userInfo?[key] as? NSValue)?.CGRectValue()
    }
    
    private func getKeyboardResponderFrame() -> CGRect? {
        return currentFirstResponder()?.frame
    }
    
    private func currentFirstResponder() -> UIView? {
        func firstResponderForSubviews(subviews:[UIView]) -> UIView? {
            for v in subviews {if v.isFirstResponder() {return v} else if let responder = firstResponderForSubviews(v.subviews) {return responder}}
            return nil
        }
        return firstResponderForSubviews(view.subviews)
    }
    
    public var firstResponders:[UIResponder] = []
    
    public var hasFirstResponders:Bool {
        get {
            for object in self.firstResponders {
                if object.isFirstResponder() {
                    return true
                }
            }
            return false
        }
    }
    
    public lazy var contentView:NGAContentView = {
        var temp = NGAContentView()
        temp.contentViewDelegate = self
        return temp
    }()
    
    public var contentViewFrame:CGRect {
        get {
            let statusBarFrame = NGADevice.statusBarFrame
            let viewBounds = view.bounds
            var temp = viewBounds
            if let navBar = navigationController?.navigationBar where navBar.translucent {temp.origin.y = navBar.bottom}
            else if navigationController == nil {temp.origin.y = adjustsForStatusBar ? statusBarFrame.size.height : 0}
            if let tabBar = tabBarController?.tabBar where tabBar.translucent {temp.size.height = viewBounds.size.height - tabBar.frameHeight}
            temp.size.height = temp.size.height - temp.origin.y
            return temp
        }
        
    }
    
    public var viewIsCurrentlyDisplayed:Bool {get {return isViewLoaded() && view.window != nil}}
    
    public var landscape:Bool {get{return view.frameWidth > view.frameHeight}}
    public var portrait:Bool {get{return view.frameWidth < view.frameHeight}}
    public var square:Bool {get{return view.frameWidth == view.frameHeight}}
    
    //MARK: View Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        postInit()
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    public override func loadView() {
        super.loadView()
        postLoad()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setContentViewFrame()
        self.view.addSubview(self.contentView)
        setup()
        
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
    
    public func postInit() {}
    
    public func postLoad() {}
    
    public func setup(){}
    
    //MARK: Frames
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setContentViewFrame()
    }
    
    public func setContentViewFrame() {
        let newContentViewFrame = contentViewFrame
        let updateSubViews = contentView.frameSize != newContentViewFrame.size
        contentView.frame = newContentViewFrame
        if updateSubViews {self.setFramesForSubviews()}
    }
    
    public func setFramesForSubviews() {}
    
    //MARK: Transition
    
    public override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let block:VoidBlock = {
            if let presenter = self.tabBarController ?? self.navigationController {
                presenter.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
            } else {super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)}
        }
        NGAExecute.performOnMainThread(block)
    }
    
    
    public func pushToViewController(viewController:UIViewController, animated:Bool = true) {
        NGAExecute.performOnMainThread() {self.navigationController?.pushViewController(viewController, animated: animated)}
        
    }
    
    public func popViewController() {
        NGAExecute.performOnMainThread() {self.navigationController?.popViewControllerAnimated(true)}
    }
    
    public func resignAllFirstResponders() {
        for object in firstResponders {object.resignFirstResponder()}
    }
    
    public func addResponderToFirstResponders(object:UIResponder?) {
        if !firstResponders.containsElement(object) {firstResponders.appendIfNotNil(object)}
    }
    
    public func removeResponderFromFirstResponders(object:UIResponder?) {
        firstResponders.removeElement(object)
    }
    
    public func addRespondersToFirstResponders(responders:[UIResponder]?) {
        guard let responders = responders else {return}
        for responder in responders {self.addResponderToFirstResponders(responder)}
    }
    
    public func removeRespondersToFirstResponders(responders:[UIResponder]?) {
        guard let responders = responders else {return}
        for responder in responders {self.removeResponderFromFirstResponders(responder)}
    }
    
    
    //MARK: Pop up
    public func flash(title title:String?, message:String?, cancelTitle:String?, actions:UIAlertAction?...) {
        NGAExecute.performOnMainThread() { () -> Void in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelBlock:AlertActionBlock = {(action:UIAlertAction!) -> Void in }
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel, handler: cancelBlock)
            alertController.addAction(cancelAction)
            for action in actions {if let a = action {alertController.addAction(a)}}
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}


public class NGAContentView: NGAScrollView, UIGestureRecognizerDelegate {
    
    public weak var contentViewDelegate:NGAViewController?
    
    public var willDynamicallyAdjustBottomBounds:Bool = false {
        didSet {
            self.dynamicallyAdjustBottomBounds()
        }
    }
    
    public var resignFirstResponderOnTap = true
    public var resignFirstResponderOnBoundsChange = true
    
    public lazy var tapRecognizer:UITapGestureRecognizer = {
        var temp = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        temp.delegate = self
        return temp
    }()
    
    public var bottomPadding:CGFloat = 0 {didSet{if willDynamicallyAdjustBottomBounds && oldValue != bottomPadding {dynamicallyAdjustBottomBounds()}}}
    
    
    public override func postInit() {
        super.postInit()
        self.addGestureRecognizer(tapRecognizer)
    }
    
    public override var backgroundColor:UIColor? {
        didSet {
            if self.backgroundColor != oldValue {
                self.contentViewDelegate?.view.backgroundColor = self.backgroundColor
            }
        }
    }
    
    public override func addSubview(view: UIView) {
        super.addSubview(view)
        dynamicallyAdjustBottomBounds()
    }
    
    public override var frame:CGRect {
        didSet {
            if frame.size != oldValue.size {
                dynamicallyAdjustBottomBounds()
            }
        }
    }
    
    public override var bounds:CGRect {
        didSet {
            if self.scrollEnabled && self.resignFirstResponderOnBoundsChange {
                self.contentViewDelegate?.resignAllFirstResponders()
            }
        }
    }
    
    
    
    public func dynamicallyAdjustBottomBounds() {
        guard willDynamicallyAdjustBottomBounds else {return}
        var newBounds = bounds
        let bottom = frameHeight
        var lowestPoint:CGFloat = 0
        for subview in subviews {
            if subview.alpha == 0 {continue}
            let subviewBottom = subview.bottom
            if subviewBottom > lowestPoint{lowestPoint = subviewBottom}
        }
        lowestPoint += bottomPadding
        if lowestPoint > bottom {
            self.scrollEnabled = true
            newBounds.size.height = lowestPoint
        }
        else {
            self.scrollEnabled = false
            newBounds.size.height = bottom
        }
        contentSize = newBounds.size
    }
    
    public func userTapped() {
        if self.resignFirstResponderOnTap {
            self.contentViewDelegate?.resignAllFirstResponders()
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let simutaneousRecognition = true
        return simutaneousRecognition
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        var receiveTouch = true
        if gestureRecognizer == self.tapRecognizer {
            receiveTouch = self.contentViewDelegate?.hasFirstResponders ?? true
        }
        return receiveTouch
    }
    
    
    
    
}







