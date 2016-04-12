//
//  NGASwitchBar.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 3/1/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public protocol NGASwitchBarDelegate: class {
    func switchBarIndexChangedTo(index:Int)
}



public class NGASwitchBar: UIView, NGASwitchBarItemDelegate {
    
    
    public weak var delegate:NGASwitchBarDelegate?
    
    public var dropShadow:Bool = true {didSet{setFrames()}}
    
    public func addDropShadow(b:Bool = true) {
        if !b {removeShadow()}
        else {
            let offset = vertical ? CGSizeMake(1.5, 0) : CGSizeMake(0, 1.5)
            addShadowWith(radius: 1.5, offset: offset, opacity: 0.8, color: UIColor.blackColor(), path: UIBezierPath(rect: bounds))
        }
    }
    
    public var vertical:Bool = false {
        didSet {
            self.setFrames()
            
        }
    }
    
    public var index:Int = 0 {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.setIndicatorFrame()
                }) { (completed:Bool) -> Void in
                    
            }
        }
    }
    
    public var buttonTitles:[String]? {
        didSet {
            if buttonTitles != nil && oldValue != nil {
                if buttonTitles!.count > oldValue!.count {
                    let objCArray = NSArray(array: oldValue!)
                    var i = 0
                    var numberFound = 0
                    for title in buttonTitles! {
                        if !objCArray.containsObject(title) {
                            let button = NGASwitchBarItem()
                            button.tag = i
                            button.vertical = vertical
                            button.title = title
                            if let image = imageDictionary[title] as? UIImage {
                                button.image = image
                            }
                            button.label.font = self.textFont?.fontWithSize(self.fontSize)
                            button.label.textColor = self.textColor
                            button.delegate = self
                            button.imageView.tintColor = self.textColor
                            //                        self.buttonArray.addObject(button)
                            self.buttonArray.insertObject(button, atIndex: i)
                            numberFound += 1
                            if i <= index {
                                index += 1
                            }
                        }
                        else if numberFound > 0 {
                            if let button = buttonArray[i] as? NGASwitchBarItem{
                                button.tag += numberFound
                            }
                        }
                        i += 1
                    }
                    if numberFound > 0{
                        self.setFrames()
                    }
                }
                else if buttonTitles!.count < oldValue!.count {
                    let objCArray = NSArray(array: buttonTitles!)
                    var i = 0
                    var numberFound = 0
//                    var buttonCount = buttonArray.count
                    for title in oldValue! {
                        if !objCArray.containsObject(title) {
//                            println("removing object at index \(i)")
                            if let button = buttonArray[i] as? NGASwitchBarItem {
                                button.removeFromSuperview()
                            }
                            self.buttonArray.removeObjectAtIndex(i)
//                            println("removed object at index \(i)")
                            numberFound += 1
                            if i == index {
                                if i > 0 {
                                    index -= 1
                                }
                                else if index + 1 <= buttonArray.count {
                                    index += 1
                                }
                            }
                            else if i > index {
                                
                            }
                            else if i < index && index - 1 >= 0 {
                                index -= 1
                            }
                            
                        }
                        else if numberFound > 0 {
                            if let button = buttonArray[i - numberFound] as? NGASwitchBarItem{
                                button.tag -= numberFound
                            }
                        }
                        i += 1
                    }
                    if numberFound > 0{
                        self.setFrames()
                    }
                }
                
                
                
                
            }
            else {
                self.setup()
                
            }
            
        }
    }
    
    public var buttonArray = NSMutableArray()
    public var imageDictionary:NSDictionary = NSDictionary() {
        didSet {
            for object in buttonArray {
                if let switchBarItem = object as? NGASwitchBarItem {
                    if let title = switchBarItem.title {
                        if let image = imageDictionary[title] as? UIImage {
                            switchBarItem.image = image
                        }
                        else {
                            switchBarItem.image = nil
                        }
                    }
                }
            }
        }
    }
    
    override public var frame:CGRect {
        get {
            return super.frame
        }
        set {
            //            println("frame change")
            super.frame = newValue
            setFrames()
//            setup()
        }
    }
    
    public var indicator = UIView()
    
    public var textColor:UIColor = UIColor.blackColor() {
        didSet {
            self.setup()
            for button in buttonArray {
                if let switchBarItem = button as? NGASwitchBarItem {
                    switchBarItem.label.textColor = textColor
                    switchBarItem.imageView.tintColor = textColor
                }
            }
        }
    }
    
    public var fontSize:CGFloat = 20.0 {
        didSet {
            if fontSize != oldValue {
                self.textFont = self.textFont?.fontWithSize(fontSize)
            }
        }
    }
    
    public var textFont:UIFont? = UIFont(name: "ArialRoundedMTBold", size: 20.0) {
        didSet {
            if textFont != oldValue && textFont != nil {
                for button in buttonArray {
                    if let switchBarItem = button as? NGASwitchBarItem {
                        switchBarItem.label.font = textFont
                    }
                }
            }
        }
    }
    
    public var indicatorColor:UIColor = UIColor.blackColor() {
        didSet {
            if indicatorColor != oldValue {
                indicator.backgroundColor = indicatorColor
            }
            
        }
    }
    
    public var buttonWidth:CGFloat {
        get {
            if self.buttonArray.count > 0{
                let buttonCount = self.buttonArray.count
                let buttonWidth = self.frame.width / CGFloat(buttonCount)
                return buttonWidth
            }
            else {
                return 0
            }
            
        }
    }
    
    public var buttonHeight:CGFloat {
        get {
            if self.buttonArray.count > 0{
                let buttonCount = self.buttonArray.count
                let buttonHeight = self.frame.height / CGFloat(buttonCount)
                return buttonHeight
            }
            else {
                return 0
            }
            
        }
    }
    
    public var selectedTitle:String? {
        get {
            var temp:String?
            if buttonTitles != nil {
                if index <= buttonTitles!.count - 1 {
                    temp = buttonTitles![index]
                }
            }
            
            return temp
        }
    }
    
    public var behaveLikeRegularBar = false {
        didSet {
            if behaveLikeRegularBar {
                indicator.alpha = 0
            }
            else {
                indicator.alpha = 1
            }
        }
    }
    
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        //        println("init with frame")
        self.setup()
//        self.setFrames()
    }
    
    public func removeAllButtons() {
        for object in buttonArray.copy() as! NSArray {
            if let button = object as? NGASwitchBarItem {
                button.removeFromSuperview()
            }
            buttonArray.removeObject(object)
        }
        if self.subviews.count > 0 {
            for object in self.subviews {
                if let button = object as? NGASwitchBarItem {
                    button.removeFromSuperview()
                }
            }
        }
    }
    
    
    public func setup() {
//        self.backgroundColor = UIColor.whiteColor()
        
        self.removeAllButtons()
        self.setupButtons()
        self.setupIndicator()
        self.setFrames()
    }
    
    public func setupButtons() {
        var index = 0
        if buttonTitles != nil {
            for title in buttonTitles! {
                //                println("setting up \(title) button")
                let button = NGASwitchBarItem()
                button.tag = index
                button.vertical = vertical
                button.title = title
                if let image = imageDictionary[title] as? UIImage {
                    button.image = image
                }
                button.label.font = self.textFont?.fontWithSize(self.fontSize)
                button.label.textColor = self.textColor
                button.delegate = self
                button.imageView.tintColor = self.textColor
                self.buttonArray.addObject(button)
                button.backgroundColor = UIColor.clearColor()
                index += 1
            }
        }
        else {
            //            println("no button titles")
        }
        
    }
    
    public func setupIndicator() {
        self.indicator.backgroundColor = self.indicatorColor
    }
    
    public func setFrames() {
        
        setButtonFrames()
        setIndicatorFrame()
        
        addDropShadow(dropShadow)
        
    }
    
    public func setButtonFrames() {
        let viewBounds = self.bounds
        var i = 0
        for object in self.buttonArray.copy() as! NSArray {
            if let button = object as? NGASwitchBarItem {
                button.vertical = vertical
                var buttonFrame = viewBounds
                if vertical {
                    
                    buttonFrame.origin.y = self.buttonHeight * CGFloat(i)
                    buttonFrame.size.height = self.buttonHeight
                    buttonFrame.size.width = buttonFrame.size.width * 0.9
                }
                else {
                    buttonFrame.origin.x = self.buttonWidth * CGFloat(i)
                    buttonFrame.size.width = self.buttonWidth
                }
                button.frame = buttonFrame
                if !button.isDescendantOfView(self) {
                    self.addSubview(button)
                }
//                println("setting frame for button with title \(button.title)")
                
                i += 1
            }
        }
    }
    
    public func setIndicatorFrame() {
        let viewBounds = self.bounds
        var indicatorFrame = viewBounds
        if vertical {
            let indicatorWidth = viewBounds.size.width * 0.1
            let indicatorHeight = self.buttonHeight * 0.8
            let indicatorYInset = (self.buttonHeight - indicatorHeight) / 2
            
            indicatorFrame.origin.y = self.buttonHeight * CGFloat(self.index) + indicatorYInset
            indicatorFrame.origin.x = viewBounds.size.width - indicatorWidth
            indicatorFrame.size = CGSizeMake(indicatorWidth, indicatorHeight)
        }
        else {
            let indicatorWidth = self.buttonWidth * 0.8
            let indicatorXInset = (self.buttonWidth - indicatorWidth) / 2
            let indicatorHeight = viewBounds.size.height * 0.1
            indicatorFrame.origin.x = self.buttonWidth * CGFloat(self.index) + indicatorXInset
            indicatorFrame.origin.y = viewBounds.size.height - indicatorHeight
            indicatorFrame.size = CGSizeMake(indicatorWidth, indicatorHeight)
        }
        
        self.indicator.frame = indicatorFrame
        self.addSubview(self.indicator)
    }
    
    
    
    
    public func buttonPressed(button:NGASwitchBarItem) {
        let buttonIndex = button.tag
        if self.index != buttonIndex || behaveLikeRegularBar {
            self.index = buttonIndex
            self.delegate?.switchBarIndexChangedTo(self.index)
        }
        
    }
    
    
    public func addTitle(title:String, toIndex index:Int) {
        var titles = self.buttonTitles
        if titles == nil {
            titles = []
        }
        let oldTitle = self.titleAtIndex(self.index)
        
        titles?.insert(title, atIndex: index)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.buttonTitles = titles
            if oldTitle != nil {
                self.selectIndexOfTitle(oldTitle!)
            }
            
            }) { (completed:Bool) -> Void in
                
        }
        
        
        
    }
    
    public func addTitle(title:String) {
        var index = 0
        if self.buttonTitles != nil {
            index = self.buttonTitles!.count
        }
        
        self.addTitle(title, toIndex: index)
        
    }
    
    public func removeTitle(title:String) {
        if let index = self.indexOfTitle(title) {
            self.removeTitleAtIndex(index)
            self.removeImageForTitle(title)
        }
    }
    
    public func removeTitleAtIndex(index:Int) {
        if var titles = buttonTitles {
            titles.removeAtIndex(index)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.buttonTitles = titles
                }) { (completed:Bool) -> Void in
                    if self.buttonTitles != nil {
                        if index <= self.buttonTitles!.count - 1 {
                            self.index = index
                        }
                        else {
                            self.index = self.buttonTitles!.count
                        }
                    }
                    else {
                        self.index = 0
                    }
            }
        }
    }
    
    
    public func selectIndexOfTitle(title:String) {
        if let nonNilIndex = self.indexOfTitle(title) {
            self.index = nonNilIndex
        }
        
    }
    
    
    public func addImage(image:UIImage?, forTitle title:String) {
        if image != nil {
            let mutableDictionary = imageDictionary.mutableCopy() as! NSMutableDictionary
            mutableDictionary.setValue(image, forKey: title)
            imageDictionary = mutableDictionary.copy() as! NSDictionary
        }
    }
    
    public func removeImageForTitle(title:String?) {
        if title != nil {
            let mutableDictionary = imageDictionary.mutableCopy() as! NSMutableDictionary
            mutableDictionary.removeObjectForKey(title!)
            imageDictionary = mutableDictionary.copy() as! NSDictionary
        }
    }
    
    //MARK: Helper Mehods
    
    public func titleAtIndex(index:Int) -> String? {
        var temp:String?
        if buttonTitles != nil {
            if index <= buttonTitles!.count - 1 {
                temp = buttonTitles![index]
            }
        }
        
        return temp
    }
    
    public func indexOfTitle(title:String) -> Int? {
        var temp:Int?
        if buttonTitles != nil {
            var i = 0
            for buttonTitle in buttonTitles! {
                if buttonTitle.lowercaseString == title.lowercaseString {
                    temp = i
                    break
                }
                i += 1
            }
            
        }
        
        
        return temp
    }
    
    public func titleExists(title:String) -> Bool {
        let temp = (self.indexOfTitle(title) != nil)
        return temp
    }
    
    public func selectedTitleIs(title:String) -> Bool {
        var temp = false
        if self.selectedTitle != nil && self.selectedTitle == title {
            temp = true
        }
        
        return temp
    }
    
    
    
    
}



public protocol NGASwitchBarItemDelegate: class {
    func buttonPressed(button:NGASwitchBarItem)
}




public class NGASwitchBarItem: UIView {
    
    public weak var delegate:NGASwitchBarItemDelegate?
    public var title:String? {
        didSet {
            let canCreateImage = title != nil && image != nil
            let shouldCreateImage = canCreateImage && (!captionedImagePresent || title != oldValue)
            if shouldCreateImage {
//                println("creating captioned image from title")
                createCaptionedImage()
            }
            if title != nil {
                label.text = title
            }
        }
    }
    public var image:UIImage? {
        didSet {
            let canCreateImage = title != nil && image != nil
            let shouldCreateImage = canCreateImage && (!captionedImagePresent || image != oldValue)
            if shouldCreateImage {
//                println("creating captioned image from image")
                createCaptionedImage()
            }
        }
    }
    public lazy var imageView:UIImageView = {
       var temp = UIImageView()
        temp.contentMode = UIViewContentMode.ScaleAspectFit
        return temp
    }()
    public lazy var label:UILabel = {
        var temp = UILabel()
        temp.textAlignment = NSTextAlignment.Center
        return temp
    }()
    public var captionedImagePresent = false
    public lazy var tapGestureRecognizer:UITapGestureRecognizer = {
        var temp = UITapGestureRecognizer(target: self, action: #selector(switchBarItemTapped))
        return temp
    }()
    
    public var vertical:Bool = false {
        didSet {
            if vertical != oldValue {
                setFrames()
            }
        }
    }
    
    public override var frame:CGRect {
        didSet {
            if frame.size != oldValue.size {
                setFrames()
            }
        }
    }
    
    public func switchBarItemTapped() {
        if delegate != nil {
            delegate?.buttonPressed(self)
        }
    }
    

    convenience required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGestureRecognizer)
        self.setFrames()
    }
    
    public func createCaptionedImage() {
        if var imageSize = image?.size {
            let shortSide = imageSize.width > imageSize.height ? imageSize.height : imageSize.width
            if shortSide == 0 {return}
            let factor = 200 / shortSide
            if factor > 1 {imageSize = CGSizeMake(imageSize.width * factor, imageSize.height * factor)}
            
//            var captionedImage = image?.captionedImageWith(caption: title)
            let captionedImage = image?.captionedImageWith(caption: title, size: imageSize, andFont: nil)
            if captionedImage != nil {
                imageView.image = captionedImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                captionedImagePresent = true
                if vertical {
                    label.alpha = 0
                    imageView.alpha = 1
                }
            }
            
        }
        
        
        
    }
    
    public func setFrames() {
        label.sizeToFit()
        label.centerInView(self)
        self.addSubview(label)
        self.imageView.frame = self.bounds
        self.imageView.longSide = self.shortSide
        self.imageView.placeViewInView(view: self, andPosition: NGARelativeViewPosition.AlignCenter)
        self.addSubview(imageView)
        
        if vertical && imageView.image != nil {
            label.alpha = 0
            imageView.alpha = 1
        }
        else {
            label.alpha = 1
            imageView.alpha = 0
        }
        
//        println(self.frame.size)
    }
    
}












//MARK: Scrolling Bar

public class NGAScrollingSwitchBar: UIScrollView, NGASwitchBarItemDelegate {
    
    
    public weak var barDelegate:NGASwitchBarDelegate?
    
    public var dropShadow:Bool = true {didSet{setFramesOnMainThread()}}
    
    public func addDropShadow(b:Bool = true) {
        if !b {removeShadow()}
        else {
            let offset = vertical ? CGSizeMake(1.5, 0) : CGSizeMake(0, 1.5)
            addShadowWith(radius: 1.5, offset: offset, opacity: 0.8, color: UIColor.blackColor(), path: UIBezierPath(rect: bounds))
        }
    }
    
    public var vertical:Bool = false {
        didSet {
            self.setFramesOnMainThread()
            
        }
    }
    
    public var index:Int = 0 {
        didSet {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.setIndicatorFrame()
                }) { (completed:Bool) -> Void in
                    
            }
        }
    }
    
    public var buttonTitles:[String]? {
        didSet {
            if buttonTitles != nil && oldValue != nil {
                if buttonTitles!.count > oldValue!.count {
                    let objCArray = NSArray(array: oldValue!)
                    var i = 0
                    var numberFound = 0
                    for title in buttonTitles! {
                        if !objCArray.containsObject(title) {
                            let button = NGASwitchBarItem()
                            button.tag = i
                            button.vertical = vertical
                            button.title = title
                            if let image = imageDictionary[title] as? UIImage {
                                button.image = image
                            }
                            button.label.font = self.textFont?.fontWithSize(self.fontSize)
                            button.label.textColor = self.textColor
                            button.delegate = self
                            button.imageView.tintColor = self.textColor
                            //                        self.buttonArray.addObject(button)
                            self.buttonArray.insertObject(button, atIndex: i)
                            numberFound += 1
                            if i <= index {
                                index += 1
                            }
                        }
                        else if numberFound > 0 {
                            if let button = buttonArray[i] as? NGASwitchBarItem{
                                button.tag += numberFound
                            }
                        }
                        i += 1
                    }
                    if numberFound > 0{
                        self.setFramesOnMainThread()
                    }
                }
                else if buttonTitles!.count < oldValue!.count {
                    let objCArray = NSArray(array: buttonTitles!)
                    var i = 0
                    var numberFound = 0
                    //                    var buttonCount = buttonArray.count
                    for title in oldValue! {
                        if !objCArray.containsObject(title) {
                            //                            println("removing object at index \(i)")
                            if let button = buttonArray[i] as? NGASwitchBarItem {
                                button.removeFromSuperview()
                            }
                            self.buttonArray.removeObjectAtIndex(i)
                            //                            println("removed object at index \(i)")
                            numberFound += 1
                            if i == index {
                                if i > 0 {
                                    index -= 1
                                }
                                else if index + 1 <= buttonArray.count {
                                    index += 1
                                }
                            }
                            else if i > index {
                                
                            }
                            else if i < index && index - 1 >= 0 {
                                index -= 1
                            }
                            
                        }
                        else if numberFound > 0 {
                            if let button = buttonArray[i - numberFound] as? NGASwitchBarItem{
                                button.tag -= numberFound
                            }
                        }
                        i += 1
                    }
                    if numberFound > 0{
                        self.setFramesOnMainThread()
                    }
                }
                
                
                
                
            }
            else {
                self.setup()
                
            }
            
        }
    }
    
    public var buttonArray = NSMutableArray()
    public var imageDictionary:NSDictionary = NSDictionary() {
        didSet {
            for object in buttonArray {
                if let switchBarItem = object as? NGASwitchBarItem {
                    if let title = switchBarItem.title {
                        if let image = imageDictionary[title] as? UIImage {
                            switchBarItem.image = image
                        }
                        else {
                            switchBarItem.image = nil
                        }
                    }
                }
            }
        }
    }
    
    public override var frame:CGRect {didSet{
        if frame != oldValue {
            setFramesOnMainThread()
        }
        }}
    
    public var indicator = UIView()
    
    public var textColor:UIColor = UIColor.blackColor() {
        didSet {
            self.setup()
            for button in buttonArray {
                if let switchBarItem = button as? NGASwitchBarItem {
                    switchBarItem.label.textColor = textColor
                    switchBarItem.imageView.tintColor = textColor
                }
            }
        }
    }
    
    public var fontSize:CGFloat = 20.0 {
        didSet {
            if fontSize != oldValue {
                self.textFont = self.textFont?.fontWithSize(fontSize)
            }
        }
    }
    
    public var textFont:UIFont? = UIFont(name: "ArialRoundedMTBold", size: 20.0) {
        didSet {
            if textFont != oldValue && textFont != nil {
                for button in buttonArray {
                    if let switchBarItem = button as? NGASwitchBarItem {
                        switchBarItem.label.font = textFont
                    }
                }
            }
        }
    }
    
    public var indicatorColor:UIColor = UIColor.blackColor() {
        didSet {
            if indicatorColor != oldValue {
                indicator.backgroundColor = indicatorColor
            }
            
        }
    }
    
    
    public var allowsScrolling:Bool = true {didSet{scrollEnabled = allowsScrolling;if allowsScrolling != oldValue{setFramesOnMainThread()}}}
    
    public var buttonsPerFrame:CGFloat = 3 {didSet{if buttonsPerFrame != oldValue{setFramesOnMainThread()}}}
    
    
    public var buttonWidth:CGFloat {
        get {
            if self.buttonArray.count > 0{
                let buttonCount = self.buttonArray.count
                let buttonWidth = allowsScrolling ? self.frame.width / buttonsPerFrame : self.frame.width / CGFloat(buttonCount)
                return buttonWidth
            }
            else {
                return 0
            }
            
        }
    }
    
    public var buttonHeight:CGFloat {
        get {
            if self.buttonArray.count > 0{
                let buttonCount = self.buttonArray.count
                let buttonHeight = allowsScrolling ? self.frame.height / buttonsPerFrame : self.frame.height / CGFloat(buttonCount)
                return buttonHeight
            }
            else {
                return 0
            }
            
        }
    }
    
    public var selectedTitle:String? {
        get {
            var temp:String?
            if buttonTitles != nil {
                if index <= buttonTitles!.count - 1 {
                    temp = buttonTitles![index]
                }
            }
            
            return temp
        }
    }
    
    public var behaveLikeRegularBar = false {
        didSet {
            if behaveLikeRegularBar {
                indicator.alpha = 0
            }
            else {
                indicator.alpha = 1
            }
        }
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //        println("init with frame")
        scrollEnabled = allowsScrolling
        userInteractionEnabled = true
        self.setup()
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        //        self.setFrames()
    }
    
    public func removeAllButtons() {
        for object in buttonArray.copy() as! NSArray {
            if let button = object as? NGASwitchBarItem {
                button.removeFromSuperview()
            }
            buttonArray.removeObject(object)
        }
        if self.subviews.count > 0 {
            for object in self.subviews {
                if let button = object as? NGASwitchBarItem {
                    button.removeFromSuperview()
                }
            }
        }
    }
    
    
    public func setup() {
        //        self.backgroundColor = UIColor.whiteColor()
        
        self.removeAllButtons()
        self.setupButtons()
        self.setupIndicator()
        self.setFrames()
    }
    
    public func setupButtons() {
        var index = 0
        if buttonTitles != nil {
            for title in buttonTitles! {
                //                println("setting up \(title) button")
                let button = NGASwitchBarItem()
                button.tag = index
                button.vertical = vertical
                button.title = title
                if let image = imageDictionary[title] as? UIImage {
                    button.image = image
                }
                button.label.font = self.textFont?.fontWithSize(self.fontSize)
                button.label.textColor = self.textColor
                button.delegate = self
                button.imageView.tintColor = self.textColor
                self.buttonArray.addObject(button)
                button.backgroundColor = UIColor.clearColor()
                index += 1
            }
        }
        else {
            //            println("no button titles")
        }
        
    }
    
    public func setupIndicator() {
        self.indicator.backgroundColor = self.indicatorColor
    }
    
    public func setFrames() {
        
        setButtonFrames()
        setIndicatorFrame()
        
        addDropShadow(dropShadow)
        
    }
    
    public func setButtonFrames() {
        let viewBounds = self.frame
        var i = 0
        let arr = self.buttonArray.toArray()
        var sTop:CGFloat = 0 ; var sLeft:CGFloat = 0; var sRight:CGFloat = 0; var sBottom:CGFloat = 0
        for object in arr {
            if let button = object as? NGASwitchBarItem {
                button.vertical = vertical
                var buttonFrame = viewBounds
                if vertical {
                    
                    buttonFrame.origin.y = self.buttonHeight * CGFloat(i)
                    buttonFrame.origin.x = 0
                    buttonFrame.size.height = self.buttonHeight
                    buttonFrame.size.width = buttonFrame.size.width * 0.9
                }
                else {
                    buttonFrame.origin.y = 0
                    buttonFrame.origin.x = self.buttonWidth * CGFloat(i)
                    buttonFrame.size.width = self.buttonWidth
                    buttonFrame.size.height = buttonFrame.size.height * 0.9
                }

                button.frame = buttonFrame
                if !button.isDescendantOfView(self) {
                    self.addSubview(button)
                }
                //                println("setting frame for button with title \(button.title)")
                if i == 0 {sTop = button.top; sLeft = button.left} else if i == arr.count - 1 {sBottom = button.bottom; sRight = button.right}
                
                i += 1
            }
        }
        if vertical {sRight = viewBounds.width} else {sBottom = viewBounds.height}
        
        contentSize = CGSizeMake(sRight - sLeft, sBottom - sTop)
//        print(contentSize)
//        var b = bounds
//        b.size = contentSize
//        bounds = b
        
    }
    
    public func setFramesOnMainThread() {
        dispatch_async(dispatch_get_main_queue(), setFrames)
    }
    
    public func setIndicatorFrame() {
        let viewBounds = self.bounds
        var indicatorFrame = viewBounds
        if vertical {
            let indicatorWidth = viewBounds.size.width * 0.1
            let indicatorHeight = self.buttonHeight * 0.8
            let indicatorYInset = (self.buttonHeight - indicatorHeight) / 2
            
            indicatorFrame.origin.y = self.buttonHeight * CGFloat(self.index) + indicatorYInset
            indicatorFrame.origin.x = viewBounds.size.width - indicatorWidth
            indicatorFrame.size = CGSizeMake(indicatorWidth, indicatorHeight)
        }
        else {
            let indicatorWidth = self.buttonWidth * 0.8
            let indicatorXInset = (self.buttonWidth - indicatorWidth) / 2
            let indicatorHeight = viewBounds.size.height * 0.1
            indicatorFrame.origin.x = self.buttonWidth * CGFloat(self.index) + indicatorXInset
            indicatorFrame.origin.y = viewBounds.size.height - indicatorHeight
            indicatorFrame.size = CGSizeMake(indicatorWidth, indicatorHeight)
        }
        
        self.indicator.frame = indicatorFrame
        self.addSubview(self.indicator)
    }
    
    
    
    
    public func buttonPressed(button:NGASwitchBarItem) {
        let buttonIndex = button.tag
        if self.index != buttonIndex || behaveLikeRegularBar {
            self.index = buttonIndex
            self.barDelegate?.switchBarIndexChangedTo(self.index)
        }
        
    }
    
    
    public func addTitle(title:String, toIndex index:Int) {
        var titles = self.buttonTitles
        if titles == nil {
            titles = []
        }
        let oldTitle = self.titleAtIndex(self.index)
        
        titles?.insert(title, atIndex: index)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.buttonTitles = titles
            if oldTitle != nil {
                self.selectIndexOfTitle(oldTitle!)
            }
            
            }) { (completed:Bool) -> Void in
                
        }
        
        
        
    }
    
    public func addTitle(title:String) {
        var index = 0
        if self.buttonTitles != nil {
            index = self.buttonTitles!.count
        }
        
        self.addTitle(title, toIndex: index)
        
    }
    
    public func removeTitle(title:String) {
        if let index = self.indexOfTitle(title) {
            self.removeTitleAtIndex(index)
            self.removeImageForTitle(title)
        }
    }
    
    public func removeTitleAtIndex(index:Int) {
        if var titles = buttonTitles {
            titles.removeAtIndex(index)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.buttonTitles = titles
                }) { (completed:Bool) -> Void in
                    if self.buttonTitles != nil {
                        if index <= self.buttonTitles!.count - 1 {
                            self.index = index
                        }
                        else {
                            self.index = self.buttonTitles!.count
                        }
                    }
                    else {
                        self.index = 0
                    }
            }
        }
    }
    
    
    public func selectIndexOfTitle(title:String) {
        if let nonNilIndex = self.indexOfTitle(title) {
            self.index = nonNilIndex
        }
        
    }
    
    
    public func addImage(image:UIImage?, forTitle title:String) {
        if image != nil {
            let mutableDictionary = imageDictionary.mutableCopy() as! NSMutableDictionary
            mutableDictionary.setValue(image, forKey: title)
            imageDictionary = mutableDictionary.copy() as! NSDictionary
        }
    }
    
    public func removeImageForTitle(title:String?) {
        if title != nil {
            let mutableDictionary = imageDictionary.mutableCopy() as! NSMutableDictionary
            mutableDictionary.removeObjectForKey(title!)
            imageDictionary = mutableDictionary.copy() as! NSDictionary
        }
    }
    
    //MARK: Helper Mehods
    
    public func titleAtIndex(index:Int) -> String? {
        var temp:String?
        if buttonTitles != nil {
            if index <= buttonTitles!.count - 1 {
                temp = buttonTitles![index]
            }
        }
        
        return temp
    }
    
    public func indexOfTitle(title:String) -> Int? {
        var temp:Int?
        if buttonTitles != nil {
            var i = 0
            for buttonTitle in buttonTitles! {
                if buttonTitle.lowercaseString == title.lowercaseString {
                    temp = i
                    break
                }
                i += 1
            }
            
        }
        
        
        return temp
    }
    
    public func titleExists(title:String) -> Bool {
        let temp = (self.indexOfTitle(title) != nil)
        return temp
    }
    
    public func selectedTitleIs(title:String) -> Bool {
        var temp = false
        if self.selectedTitle != nil && self.selectedTitle == title {
            temp = true
        }
        
        return temp
    }
    
    
    
    
}





































