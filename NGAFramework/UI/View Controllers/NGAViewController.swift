//
//  ViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import UIKit


open class NGAViewController: UIViewController {
    
    //MARK: Properties
    open var adjustsForStatusBar:Bool = true {didSet{if oldValue != adjustsForStatusBar { setContentViewFrame()}}}
    
    open var adjustsForKeyboard = false {
        didSet{
            if oldValue != adjustsForKeyboard {
                NGAExecute.performOnMainThread() {self.setupAdjustsForKeyboard(self.adjustsForKeyboard)}
            }
        }
    }
    
    open func setupAdjustsForKeyboard(_ newValue:Bool) {
        let notificationCenter = NotificationCenter.default
        if newValue {
            notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        } else {
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    
    
    open func keyboardDidShow(_ notification:Notification?) {
        guard let kbFrame = getKeyboardRectFromNotification(notification), let r = currentFirstResponder(), let w = window , viewIsCurrentlyDisplayed else {return}
        if !r.isDescendant(of: contentView) {return}
        let rFrame = r.frame
        let absoluteRect = w.convert(rFrame, from: r.superview)
        let diff = (w.frameHeight - kbFrame.height) - (absoluteRect.origin.y + absoluteRect.height)
        if diff < 0 {contentView.top = contentViewFrame.origin.y + diff}
    }
    
    open func keyboardDidHide(_ notification:Notification?) {setContentViewFrame()}
    
    fileprivate func getKeyboardRectFromNotification(_ notification:Notification?, beginFrame:Bool = false) -> CGRect? {
        let key = beginFrame ? UIKeyboardFrameBeginUserInfoKey : UIKeyboardFrameEndUserInfoKey
        return ((notification as NSNotification?)?.userInfo?[key] as? NSValue)?.cgRectValue
    }
    
    fileprivate func getKeyboardResponderFrame() -> CGRect? {
        return currentFirstResponder()?.frame
    }
    
    fileprivate func currentFirstResponder() -> UIView? {
        func firstResponderForSubviews(_ subviews:[UIView]) -> UIView? {
            for v in subviews {if v.isFirstResponder {return v} else if let responder = firstResponderForSubviews(v.subviews) {return responder}}
            return nil
        }
        return firstResponderForSubviews(view.subviews)
    }
    
    open var firstResponders:[UIResponder] = []
    
    open var hasFirstResponders:Bool {
        get {
            for object in self.firstResponders {
                if object.isFirstResponder {
                    return true
                }
            }
            return false
        }
    }
    
    open lazy var contentView:NGAContentView = {
        var temp = NGAContentView()
        temp.contentViewDelegate = self
        return temp
    }()
    
    open var contentViewFrame:CGRect {
        get {
            let statusBarFrame = NGADevice.statusBarFrame
            let viewBounds = view.bounds
            var temp = viewBounds
            if let navBar = navigationController?.navigationBar , navBar.isTranslucent {temp.origin.y = navBar.bottom}
            else if navigationController == nil {temp.origin.y = adjustsForStatusBar ? statusBarFrame.size.height : 0}
            if let tabBar = tabBarController?.tabBar , tabBar.isTranslucent {temp.size.height = viewBounds.size.height - tabBar.frameHeight}
            temp.size.height = temp.size.height - temp.origin.y
            return temp
        }
        
    }
    
    open var viewIsCurrentlyDisplayed:Bool {get {return isViewLoaded && view.window != nil}}
    
    open var landscape:Bool {get{return view.frameWidth > view.frameHeight}}
    open var portrait:Bool {get{return view.frameWidth < view.frameHeight}}
    open var square:Bool {get{return view.frameWidth == view.frameHeight}}
    
    //MARK: View Cycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        postInit()
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    open override func loadView() {
        super.loadView()
        postLoad()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setContentViewFrame()
        self.view.addSubview(self.contentView)
        setup()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdjustsForKeyboard(adjustsForKeyboard)
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupAdjustsForKeyboard(false)
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    //MARK: Memory Warning
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Setup
    
    open func postInit() {}
    
    open func postLoad() {}
    
    open func setup(){}
    
    //MARK: Frames
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setContentViewFrame()
    }
    
    open func setContentViewFrame() {
        let newContentViewFrame = contentViewFrame
        let updateSubViews = contentView.frameSize != newContentViewFrame.size
        contentView.frame = newContentViewFrame
        if updateSubViews {self.setFramesForSubviews()}
    }
    
    open func setFramesForSubviews() {}
    
    //MARK: Transition
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let block:VoidBlock = {
            if let presenter = self.tabBarController ?? self.navigationController {
                presenter.present(viewControllerToPresent, animated: flag, completion: completion)
            } else {super.present(viewControllerToPresent, animated: flag, completion: completion)}
        }
        NGAExecute.performOnMainThread(block)
    }
    
    
    open func pushToViewController(_ viewController:UIViewController, animated:Bool = true) {
        NGAExecute.performOnMainThread() {self.navigationController?.pushViewController(viewController, animated: animated)}
        
    }
    
    open func popViewController() {
        NGAExecute.performOnMainThread() {let _=self.navigationController?.popViewController(animated: true)}
    }
    
    open func resignAllFirstResponders() {
        for object in firstResponders {object.resignFirstResponder()}
    }
    
    open func addResponderToFirstResponders(_ object:UIResponder?) {
        if !firstResponders.containsElement(object) {let _=firstResponders.appendIfNotNil(object)}
    }
    
    open func removeResponderFromFirstResponders(_ object:UIResponder?) {
        firstResponders.removeElement(object)
    }
    
    open func addRespondersToFirstResponders(_ responders:[UIResponder]?) {
        guard let responders = responders else {return}
        for responder in responders {self.addResponderToFirstResponders(responder)}
    }
    
    open func removeRespondersToFirstResponders(_ responders:[UIResponder]?) {
        guard let responders = responders else {return}
        for responder in responders {self.removeResponderFromFirstResponders(responder)}
    }
    
    
//    //MARK: Pop up
//    public func flash(title title:String?, message:String?, cancelTitle:String?, actions:UIAlertAction?...) {
//        NGAExecute.performOnMainThread() { () -> Void in
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelBlock:AlertActionBlock = {(action:UIAlertAction) -> Void in }
//            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel, handler: cancelBlock)
//            alertController.addAction(cancelAction)
//            for action in actions {if let action = action {alertController.addAction(action)}}
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
//    }
//    
//    public func flash(title title:String?, message:String?, cancelTitle:String?, actions:[UIAlertAction]?) {
//        NGAExecute.performOnMainThread() { () -> Void in
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            let cancelBlock:AlertActionBlock = {(action:UIAlertAction) -> Void in }
//            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel, handler: cancelBlock)
//            alertController.addAction(cancelAction)
//            if let actions = actions {for action in actions {alertController.addAction(action)}}
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
//    }
    
}

public extension UIViewController {
    //MARK: Pop up
    public func flash(title:String?, message:String?, cancelTitle:String?, actions:UIAlertAction?...) {
        NGAExecute.performOnMainThread() { () -> Void in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let cancelBlock:AlertActionBlock = {(action:UIAlertAction) -> Void in }
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: cancelBlock)
            alertController.addAction(cancelAction)
            for action in actions {if let action = action {alertController.addAction(action)}}
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func flash(title:String?, message:String?, cancelTitle:String?, actions:[UIAlertAction]) {
        NGAExecute.performOnMainThread() { () -> Void in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let cancelBlock:AlertActionBlock = {(action:UIAlertAction) -> Void in }
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: cancelBlock)
            alertController.addAction(cancelAction)
            for action in actions {alertController.addAction(action)}
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


open class NGAContentView: NGAScrollView, UIGestureRecognizerDelegate {
    
    open weak var contentViewDelegate:NGAViewController?
    
    open var willDynamicallyAdjustBottomBounds:Bool = false {
        didSet {
            self.dynamicallyAdjustBottomBounds()
        }
    }
    
    open var resignFirstResponderOnTap = true
    open var resignFirstResponderOnBoundsChange = true
    
    open lazy var tapRecognizer:UITapGestureRecognizer = {
        var temp = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        temp.delegate = self
        return temp
    }()
    
    open var bottomPadding:CGFloat = 0 {didSet{if willDynamicallyAdjustBottomBounds && oldValue != bottomPadding {dynamicallyAdjustBottomBounds()}}}
    
    
    open override func postInit() {
        super.postInit()
        self.addGestureRecognizer(tapRecognizer)
    }
    
    open override var backgroundColor:UIColor? {
        didSet {
            if self.backgroundColor != oldValue {
                self.contentViewDelegate?.view.backgroundColor = self.backgroundColor
            }
        }
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        dynamicallyAdjustBottomBounds()
    }
    
    open override var frame:CGRect {
        didSet {
            if frame.size != oldValue.size {
                dynamicallyAdjustBottomBounds()
            }
        }
    }
    
    open override var bounds:CGRect {
        didSet {
            if self.isScrollEnabled && self.resignFirstResponderOnBoundsChange {
                self.contentViewDelegate?.resignAllFirstResponders()
            }
        }
    }
    
    
    
    open func dynamicallyAdjustBottomBounds() {
        guard willDynamicallyAdjustBottomBounds else {return}
        var newBounds = bounds
        let bottom = frameHeight
        var lowestPoint:CGFloat = lowestSubviewBottom()
//        for subview in subviews {
//            if subview.alpha == 0 {continue}
//            let subviewBottom = subview.bottom
//            if subviewBottom > lowestPoint{lowestPoint = subviewBottom}
//        }
        lowestPoint += bottomPadding
        if lowestPoint > bottom {
            self.isScrollEnabled = true
            newBounds.size.height = lowestPoint
        }
        else {
            self.isScrollEnabled = false
            newBounds.size.height = bottom
        }
        contentSize = newBounds.size
    }
    
    open func userTapped() {
        if self.resignFirstResponderOnTap {
            self.contentViewDelegate?.resignAllFirstResponders()
        }
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let simutaneousRecognition = true
        return simutaneousRecognition
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var receiveTouch = true
        if gestureRecognizer == self.tapRecognizer {
            receiveTouch = self.contentViewDelegate?.hasFirstResponders ?? true
        }
        return receiveTouch
    }
    
    
    
    
}







