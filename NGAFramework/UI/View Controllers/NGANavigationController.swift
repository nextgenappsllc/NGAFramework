//
//  Custom Nav Controller.swift
//  OnDecker
//
//  Created by Jose Castellanos on 2/13/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

//public class NGANavigationController: UIViewController {
//    
//    //MARK: Properties
//    
//    public var viewControllers = NSMutableArray()
//    public var navigationItemsDictionary = NSMutableDictionary()
//    
//    public var topBar = UIView()
//    public var menuButton = UIButton()
//    public var backButton = UIButton()
//    public var homeButton = UIButton()
//    public var titleLabel = UILabel()
//    public var titleImageView = UIImageView()
//    
//    public var mainView = UIView()
//    public var mainContentView = UIView()
//    
//    public var menuView = UIView()
//    
//    public var allButtons:[UIButton] {
//        get {
//            return [self.menuButton, self.backButton, self.homeButton]
//        }
//    }
//    
//    public var removingVC = false
//    public var addingVC = false
//    public var startFrameForAnimation:CGRect?
//    
//    public weak var currentViewController : NGAViewController? {
//        didSet {
//            if currentViewController != nil {
////                println("set current VC")
//                currentViewController?.customNavigationController = self
//                self.currentView = currentViewController?.view
//            }
//        }
//    }
//    
//    public weak var currentView:UIView? {
//        didSet {
//            if currentView != nil {
////                println("set current view")
//                if oldValue == nil {
//                    self.currentView?.frame = self.currentViewFrame
//                    self.mainContentView.addSubview(currentView!)
//                    self.showButtons()
//                }
//                else {
////                    println("added current view from something")
//                    
//                    if self.addingVC {
//                        
//                        var newStartFrame = oldValue!.frame
//                        newStartFrame.origin.x = newStartFrame.size.width + newStartFrame.origin.x
//                        newStartFrame.origin.y = newStartFrame.size.height + newStartFrame.origin.y
//                        newStartFrame.size = CGSizeZero
//                        
//                        if self.startFrameForAnimation != nil {
//                            newStartFrame =  self.startFrameForAnimation!
//                            self.startFrameForAnimation = nil
//                        }
//                        
//                        let newEndFrame = oldValue!.frame
//                        
//                        self.currentView?.frame = newStartFrame
//                        self.mainContentView.addSubview(currentView!)
//                        
//                        UIView.animateWithDuration(0.2, animations: { () -> Void in
//                            for button in self.allButtons {
//                                button.alpha = 0.0
//                            }
//                            }, completion: { (success:Bool) -> Void in
//                                
//                        })
//                        
//                        UIView.animateWithDuration(0.5, animations: { () -> Void in
//                            
//                            self.currentView?.frame = newEndFrame
//                            return
//                            
//                            }, completion: { (success:Bool) -> Void in
//                                
//                                oldValue?.removeFromSuperview()
//                                self.showButtons()
//                                
//                                UIView.animateWithDuration(0.2, animations: { () -> Void in
//                                    for button in self.allButtons {
//                                        button.alpha = 1.0
//                                    }
//                                    }, completion: { (success:Bool) -> Void in
//                                        
//                                })
//                                
//                                
//                        })
//                        self.addingVC = false
//                        
//                    }
//                    else if self.removingVC {
//                        
//
//                        var newStartFrame = oldValue!.frame
//                        newStartFrame.origin.x = newStartFrame.size.width + newStartFrame.origin.x
//                        newStartFrame.origin.y = newStartFrame.size.height + newStartFrame.origin.y
//                        
//                        self.mainContentView.insertSubview(self.currentView!, belowSubview: oldValue!)
//                        
//                        UIView.animateWithDuration(0.2, animations: { () -> Void in
//                            for button in self.allButtons {
//                                button.alpha = 0.0
//                            }
//                            }, completion: { (success:Bool) -> Void in
//                                
//                        })
//                        
//                        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
//                            oldValue?.frame = newStartFrame
//                            
//                            return
//                            }, completion: { (success:Bool) -> Void in
//                                
//                                oldValue?.removeFromSuperview()
//                                let indexOfVC = self.viewControllers.indexOfObject(self.currentViewController!)
//                                self.viewControllers.removeObjectsInRange(NSMakeRange(indexOfVC + 1, self.viewControllers.count - (indexOfVC + 1)))
//                                self.showButtons()
//                                UIView.animateWithDuration(0.2, animations: { () -> Void in
//                                    for button in self.allButtons {
//                                        button.alpha = 1.0
//                                    }
//                                    }, completion: { (success:Bool) -> Void in
//                                        
//                                })
//                                //                                println("vc count = \(self.viewControllers.count)")
//                                
//                        })
//                        self.removingVC = false
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    
//    public var heightForTopBar:CGFloat {
//        get {
//            return self.view.frame.size.height * 0.1
//        }
//    }
//    
//    public var mainContentViewFrame:CGRect {
//        get {
//            var viewFrame = self.view.frame
//            viewFrame.origin.y = self.heightForTopBar
//            viewFrame.size.height = viewFrame.size.height - viewFrame.origin.y
//            
//            return viewFrame
//        }
//    }
//    
//    public var currentViewFrame:CGRect {
//        get {
//            var viewFrame = self.mainContentViewFrame
//            viewFrame.origin = CGPointZero
//            return viewFrame
//        }
//    }
//    
//    public var topBarFrame:CGRect {
//        get {
//            var topBarFrame = self.view.frame
//            topBarFrame.size.height = self.heightForTopBar
//            return topBarFrame
//        }
//    }
//    
//    
//    public var menuViewFrame:CGRect {
//        get {
//            var viewFrame = self.view.frame
////            viewFrame.origin.y = UIApplication.sharedApplication().statusBarFrame.size.height
//            viewFrame.size.width = viewFrame.size.width * 5 / 7
//            viewFrame.size.height = viewFrame.size.height - viewFrame.origin.y
//            
//            return viewFrame
//        }
//    }
//    
//    public var topBarContentFrame:CGRect {
//        get {
//            let yOrigin = UIApplication.sharedApplication().statusBarFrame.size.height
//            let xOrigin:CGFloat = 10
//            var topBarFrame = self.topBarFrame
//            topBarFrame.origin.y = yOrigin
//            topBarFrame.origin.x = xOrigin
//            topBarFrame.size.height = topBarFrame.size.height - (topBarFrame.origin.y)
//            topBarFrame.size.width = topBarFrame.size.width - (topBarFrame.origin.x * 2)
//            return topBarFrame
//        }
//    }
//    
//    public var titleViewFrame:CGRect {
//        get {
//            var topBarFrame = self.topBarContentFrame
//            topBarFrame.origin.x = topBarFrame.origin.x + (topBarFrame.size.width * 2 / 7)
//            topBarFrame.size.width = topBarFrame.size.width * 3 / 7
//            
//            return topBarFrame
//        }
//    }
//    
//    public var firstButtonFrame:CGRect {
//        get {
//            var topBarFrame = self.topBarContentFrame
//            topBarFrame.size = CGSizeMake(topBarFrame.size.width / 7, topBarFrame.size.height)
//            
//            return topBarFrame
//        }
//    }
//    
//    //MARK: Initialization
//    
////    override init() {
////        super.init()
////    }
////    
//    public convenience required init?(coder aDecoder: NSCoder) {
//        self.init()
//    }
//    
//    public convenience init(rootViewController:NGAViewController) {
//        self.init()
////        rootViewController.customNavigationController = self
//        self.viewControllers.addObject(rootViewController)
//      
//    }
//    
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    //MARK: View Cycle
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.frame = UIScreen.mainScreen().bounds
//        
//        self.menuView.backgroundColor = UIColor.darkGrayColor()
//        self.menuView.frame = self.menuViewFrame
//        self.view.addSubview(self.menuView)
//        
//        self.mainView.frame = self.view.frame
//        self.mainView.layer.zPosition = CGFloat(MAXFLOAT)
//        self.view.addSubview(self.mainView)
//        
//        setupTopBar()
//        
//        self.mainContentView.frame = self.mainContentViewFrame
//        self.mainView.addSubview(self.mainContentView)
//        
//        if self.viewControllers.count > 0 {
////            println("at least one VC")
//            if let vc = self.viewControllers.firstObject as? NGAViewController {
//                self.currentViewController = vc
//                
//            }
//        }
//    }
//    
//    public override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//    }
//    
//    public override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    
//    public override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    public override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
//    
//    
//    //MARK: Setup 
//    public func setupTopBar() {
//        self.topBar.layer.zPosition = CGFloat(MAXFLOAT)
//        self.topBar.backgroundColor = UIColor.whiteColor()
//
//        self.topBar.frame = self.topBarFrame
////        self.view.addSubview(self.topBar)
//        self.mainView.addSubview(self.topBar)
//        
//        self.setupButtons()
//        
//    }
//    
//    public func setupButtons() {
//        self.menuButton.setImage(UIImage(named: "MenuIcon"), forState: UIControlState.Normal)
//        self.menuButton.addTarget(self, action: #selector(menuButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
//        self.menuButton.contentMode = UIViewContentMode.ScaleAspectFit
//        
//        self.backButton.setImage(UIImage(named: "BackArrow"), forState: UIControlState.Normal)
//        self.backButton.addTarget(self, action: #selector(popViewController), forControlEvents: UIControlEvents.TouchUpInside)
//        self.backButton.contentMode = UIViewContentMode.ScaleAspectFit
//        
//        self.homeButton.setImage(UIImage(named: "HomeIcon"), forState: UIControlState.Normal)
//        self.homeButton.addTarget(self, action: #selector(popToRootViewController), forControlEvents: UIControlEvents.TouchUpInside)
//        self.homeButton.contentMode = UIViewContentMode.ScaleAspectFit
//        
//        self.titleImageView.image = UIImage(named: "DeckerTitle")
//        self.titleImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        self.topBar.addSubview(self.titleImageView)
//        
//        setTitleViewFrame()
//        setButtonFrames()
//        
////        self.titleImageView.backgroundColor = UIColor.redColor()
////        self.menuButton.backgroundColor = UIColor.blueColor()
////        self.homeButton.backgroundColor = UIColor.purpleColor()
////        self.backButton.backgroundColor = UIColor.orangeColor()
//        
//    }
//    
//    
//    //MARK: frames
//    
//    
//    public func setTitleViewFrame(){
//        self.titleImageView.frame = self.titleViewFrame
//        self.titleLabel.frame = self.titleImageView.frame
//    }
//    
//    public func setButtonFrames() {
//        self.menuButton.frame = self.getFrameForButton(0)
//        self.backButton.frame = self.getFrameForButton(0)
//        self.homeButton.frame = self.getFrameForButton(1)
//        
//        
//        
//    }
//    
//    //MARK: Actions
//    
//    public func menuButtonPressed() {
//        self.menuButton.enabled = false
//        var endFrame = self.mainView.frame
//        if self.mainView.frame == self.view.frame {
//            self.mainContentView.userInteractionEnabled = false
//            endFrame.origin.x = self.menuView.frame.size.width
//        }
//        else {
//            self.mainContentView.userInteractionEnabled = true
//            endFrame = self.view.frame
//        }
//        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.mainView.frame = endFrame
//            }) { (success:Bool) -> Void in
//            self.menuButton.enabled = true
//        }
//    }
//    
//    public func pushToViewController(viewController:NGAViewController) {
//        self.addingVC = true
//        self.viewControllers.addObject(viewController)
//        self.currentViewController = viewController
//    }
//    
//    public func pushToViewController(viewController:NGAViewController, with startFrame:CGRect) {
//        self.addingVC = true
//        self.startFrameForAnimation = startFrame
//        self.viewControllers.addObject(viewController)
//        self.currentViewController = viewController
//    }
//    
//    public func popViewController(){
//        if self.viewControllers.count > 1 {
//            self.removingVC = true
//            self.currentViewController = self.viewControllers.objectAtIndex(self.viewControllers.count - 2) as? NGAViewController
//        }
//    }
//    
//    public func popToRootViewController() {
//        
//        self.removingVC = true
//        self.currentViewController = self.viewControllers.firstObject as? NGAViewController
//        
//    }
//    
//    //MARK: Touches
//    
//    
////    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
////        if let touch = touches.anyObject() as? UITouch {
////            var location = touch.locationInView(self.view)
////            if !self.mainContentView.userInteractionEnabled {
////                if CGRectContainsPoint(self.mainView.frame, location) {
////                    self.menuButtonPressed()
////                }
////                
////            }
////        }
////    }
//    
//    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.locationInView(self.view)
//            if !self.mainContentView.userInteractionEnabled {
//                if CGRectContainsPoint(self.mainView.frame, location) {
//                    self.menuButtonPressed()
//                }
//                
//            }
//        }
//    }
//    
//    
//    //MARK: Helper methods
//    
//    public func getFrameForButton(buttonIndex:Int) -> CGRect {
//        var buttonFrame = self.firstButtonFrame
//        let titleViewFrame = self.titleViewFrame
//        if buttonIndex == 0 {
//            
//        }
//        else if buttonIndex == 1 {
//            buttonFrame.origin.x = buttonFrame.origin.x + buttonFrame.size.width
//        }
//        else if buttonIndex == 2 {
//            buttonFrame.origin.x = titleViewFrame.origin.x + titleViewFrame.size.width
//        }
//        else if buttonIndex == 3 {
//            buttonFrame.origin.x = titleViewFrame.origin.x + titleViewFrame.size.width + buttonFrame.size.width
//        }
//        
//        return buttonFrame
//    }
//    
//    public func showButtons() {
//        let indexOfVC = self.viewControllers.indexOfObject(currentViewController!)
//        if indexOfVC == 0 {
//            self.backButton.removeFromSuperview()
//            self.homeButton.removeFromSuperview()
//            self.topBar.addSubview(self.menuButton)
//        }
//        else if indexOfVC == 1 {
//            self.menuButton.removeFromSuperview()
//            self.homeButton.removeFromSuperview()
//            self.topBar.addSubview(self.backButton)
////            self.topBar.addSubview(self.homeButton)
//        }
//        else if indexOfVC > 1 {
//            self.menuButton.removeFromSuperview()
//            self.topBar.addSubview(self.backButton)
//            self.topBar.addSubview(self.homeButton)
//        }
//    }
//    
//    
//    public func customNavigationItemFor(viewController:NGAViewController) -> NGANavigationItem {
//        
//        let value = ObjectIdentifier(viewController).uintValue
//        
//        if let navItem = self.navigationItemsDictionary.objectForKey(value) as? NGANavigationItem {
//            return navItem
//        }
//        else {
//            let navItem = NGANavigationItem()
//            self.navigationItemsDictionary.setObject(navItem, forKey: value)
//            return navItem
//        }
//        
//    }
//    
//}
//
//
//
//
//public class NGANavigationItem {
//    
//    public weak var delegate:NGANavigationController?
//    
//    
//    public var title:String?
//    public var prompt:String?
//    public var backBarButton:UIButton?
//    public var hidesBackButton = false
//    public var leftButtonsSupplementDefault = false
//    
//    public var titleView:UIView?
//    public var leftBarButton:UIButton?
//    public var leftBarButtons:NSArray?
//    public var rightBarButton:UIButton?
//    public var rightBarButtons:NSArray?
//    
//    
//    
//}


