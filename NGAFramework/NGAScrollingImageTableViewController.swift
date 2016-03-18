//
//  NGAScrollingImageTableViewController.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


class NGAScrollingImageTableViewController: NGATableViewController {
    
    
    
    var refreshed = false
    var loadedMore = false
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NGAScrollingTableViewCell.self, forCellReuseIdentifier: "Cell")
//        setup()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    //MARK: Setup
    override func setup() {
        super.setup()

        
    }
    
    
    //MARK: Frames
    
    override func setFramesForSubviews() {
        super.setFramesForSubviews()
        
    }
    
//    override func setTableViewFrame() {
//        super.setTableViewFrame()
//        var frame = self.contentView.bounds
//        frame.origin.y = frame.size.height * 0.1
//        frame.size.height = frame.size.height - frame.origin.y
//        self.tableView.frame = frame
//    }
    
    //MARK: TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? NGAScrollingTableViewCell
        
        if cell == nil {
            cell = NGAScrollingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        let cellFrame = self.tableView.convertRect(cell!.frame, toView: self.contentView)
        let yOrigin = cellFrame.origin.y
        let viewFrame = self.tableView.frame
        if yOrigin <= viewFrame.size.height && yOrigin >=  -cellFrame.size.height {
            var newOffset = tableView.contentOffset
            if viewFrame.size.height > 0{
                newOffset.y = (cellFrame.origin.y - viewFrame.origin.y)
                
                cell!.imageScrollView.contentOffset = newOffset
                cell!.imageScrollView.imageView.frame = self.contentView.bounds
            }
            
        }
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if landscape {
//            return self.contentView.bounds.height
            return self.tableView.frame.height
        }
        return self.contentView.bounds.size.height * 0.5
//        return self.tableView.frame.height
    }
    
    //MARK: scroll view
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.tableView {
//            let viewFrame = self.contentView.bounds
            let viewFrame = self.tableView.frame
            let visibileCells = self.tableView.visibleCells
            let offset = scrollView.contentOffset
            let yOffset = offset.y
            
//            println("offset = \(offset.y) and yOffset = \(yOffset)")
//            println("yOffset = \(yOffset)")
//            println("table view bounds = \(scrollView.bounds)")
//            var i = 0
            for cell in visibileCells {
                if let cell = cell as? NGAScrollingTableViewCell {
                    //                println("cell is nga cell")
                    let cellFrame = self.tableView.convertRect(cell.frame, toView: self.contentView)
                    
                    //                var cellFrame = cell.frame
                    let yOrigin = cellFrame.origin.y
                    //                println("yOrigin = \(yOrigin) ")
                    
                    if yOrigin <= viewFrame.size.height && yOrigin >=  -cellFrame.size.height {
                        var newOffset = offset
                        if viewFrame.size.height > 0{
                            //                        println("cell origin \(cellFrame.origin.y) view origin \(viewFrame.origin.y)")
                            
                            
                            
                            
                            /////TESTING
//                            newOffset.y = -newOffset.y
//                            newOffset.y = (cellFrame.origin.y - viewFrame.origin.y) / viewFrame.size.height
                            newOffset.y = (cellFrame.origin.y - viewFrame.origin.y)
                            cell.imageScrollView.contentOffset = newOffset
                            cell.imageScrollView.imageView.frame = self.contentView.bounds
                            
                            //                        println("new offset \(newOffset.y)")
                        }
                        
                    }
                }
            }
            
            let distanceFromBottom = scrollView.contentSize.height - yOffset - viewFrame.size.height
            let threshold = -viewFrame.size.height / 5
            
//            println("distance from bottom = \(distanceFromBottom)")
            
            if distanceFromBottom < threshold {
                if !self.loadedMore {
                    self.loadedMore = true
                    self.loadMore()
                }
                
            }
            else {
                loadedMore = false
            }
            
            if yOffset < threshold {
                if !self.refreshed {
                    self.refreshed = true
                    self.refresh()
                }
                
            }
            else {
                self.refreshed = false
            }
            
        }
        
        
        
    }
    
    
    //MARK: Scrolling Responders
    func loadMore() {
        
    }
    
    func refresh() {
        
    }
    
    
    
}










class NGAScrollingTableViewCell: UITableViewCell {
    
    var titleText:String? {
        didSet {
            self.titleLabel.text = titleText
            self.setFrameForTitleLabel()
        }
    }
    
    weak var mainImage:UIImage? {
        set {
            self.imageScrollView.image = newValue
        }
        get {
            return self.imageScrollView.image
        }
    }
    
    var customContentView = UIView()
    var imageScrollView = NGAImageScrollView()
    var gradientImageView = UIImageView()
    var titleLabel = UILabel()
    
    override var frame:CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
//            self.setFrames()
        }
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
//    override init() {
//        super.init()
//        //        println("init called")
//        //        self.setup()
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        println("init with style and identifier called")
        self.setup()
    }
    
    func setup(){
        
        self.autoresizesSubviews = true
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        self.contentView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.autoresizesSubviews = true
        self.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        self.customContentView.contentMode = UIViewContentMode.ScaleAspectFill
        self.customContentView.autoresizesSubviews = true
        self.customContentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.customContentView.clipsToBounds = true
//        self.customContentView.layer.cornerRadius = 10.0
        
        if !self.customContentView.isDescendantOfView(self.contentView) {
            self.contentView.addSubview(self.customContentView)
        }
        
        self.gradientImageView.contentMode = UIViewContentMode.ScaleToFill
        self.gradientImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.gradientImageView.image = UIImage(named: "Gradient.png")
        
        self.titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.shadowColor = UIColor.blackColor()
        self.titleLabel.shadowOffset = CGSizeMake(1, 1)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.autoresizesSubviews = true
        self.titleLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.titleLabel.textAlignment = NSTextAlignment.Center
        
        self.setFrames()
        
    }
    
    func setFrames(){
        self.setFrameForCustomContentView()
        if !self.customContentView.isDescendantOfView(self.contentView) {
            self.contentView.addSubview(self.customContentView)
        }
        
        self.setFrameForScrollView()
        if !self.imageScrollView.isDescendantOfView(self.customContentView) {
            self.customContentView.addSubview(self.imageScrollView)
        }
        
        self.setFrameForGradientImageVIew()
        if !self.gradientImageView.isDescendantOfView(self.customContentView) {
            self.customContentView.addSubview(self.gradientImageView)
        }
        
        self.setFrameForTitleLabel()
        if !self.titleLabel.isDescendantOfView(self.customContentView) {
            self.customContentView.addSubview(self.titleLabel)
        }
    }
    
    func setFrameForCustomContentView(){
//        var xInset:CGFloat = 10
//        var yInset:CGFloat = 8
        let newFrame = self.bounds
        
        /////TESTING
//        newFrame.origin = CGPointMake(newFrame.origin.x + xInset, newFrame.origin.y + yInset)
//        newFrame.size = CGSizeMake(newFrame.size.width - (xInset * 2), newFrame.size.height - (yInset * 2))
        self.customContentView.frame = newFrame
    }
    func setFrameForGradientImageVIew(){
        self.gradientImageView.frame = self.customContentView.bounds
    }
    func setFrameForScrollView() {
        self.imageScrollView.frame = self.customContentView.bounds
    }
    func setFrameForTitleLabel() {
//        var xInset:CGFloat = 5
//        var yInset:CGFloat = self.customContentView.bounds.height / 2
//        var newFrame = self.customContentView.bounds
//        newFrame.origin = CGPointMake(newFrame.origin.x + xInset, newFrame.origin.y + yInset)
//        newFrame.size = CGSizeMake(newFrame.size.width - (xInset * 2), newFrame.size.height - (yInset))
//        //        var newSize = self.customContentView.bounds.size
//        
//        var newSize = self.titleLabel.sizeThatFits(newFrame.size)
//        newFrame.size = newSize
//        newFrame.origin.y = self.customContentView.bounds.height - xInset - newFrame.size.height
//        
//        
//        self.titleLabel.frame = newFrame
        self.titleLabel.setSizeFromView(self.contentView, withXRatio: 0.9, andYRatio: 0.9)
        var newFrame = self.titleLabel.frame
        let newSize = self.titleLabel.sizeThatFits(newFrame.size)
        newFrame.size = newSize
        self.titleLabel.frame = newFrame
        self.titleLabel.placeViewInView(view: self.customContentView, position: NGARelativeViewPosition.AlignTop, andPadding: (self.customContentView.bounds.size.height * 0.1))
//        self.titleLabel.placeViewInView(view: self.customContentView, position: NGARelativeViewPosition.AlignLeft, andPadding: (self.customContentView.bounds.size.width * 0.1))
        self.titleLabel.placeViewInView(view: self.customContentView, position: NGARelativeViewPosition.AlignCenterX, andPadding: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageScrollView.image = nil
    }
    
    func removeAllSubViews() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
    }
    
    
}



class NGAImageScrollView: UIScrollView {
    var imageView = UIImageView()
    
    weak var image:UIImage? {
        didSet{
            self.imageView.image = image
//            self.setImageViewFrame()
        }
    }

    
//    var testLabel = UILabel()
    
    override var contentOffset:CGPoint {
        get{
            return super.contentOffset
        }
        set{
            let newOffset = newValue
//            if let customContentView = self.superview {
//                testLabel.text = "\(newValue.y)"
//                testLabel.textColor = UIColor.greenColor()
//                testLabel.font = testLabel.font.fontWithSize(20)
//                testLabel.sizeToFit()
//                testLabel.centerInView(customContentView)
//                customContentView.addSubview(testLabel)
//            }
            
            //            if newOffset.y < 0 {
            //                newOffset.y = self.frame.size.height * newValue.y * 2
            //            }
            //            else if newOffset.y > 0.5 {
            //                newOffset.y = (self.frame.size.height * (newValue.y - 0.5) * 2) + (self.imageView.frame.size.height - self.frame.size.height)
            //            }
            //            else {
            //                newOffset.y = (newOffset.y * (self.imageView.frame.size.height - self.frame.size.height) * 2)
            //            }
            
            //            if newOffset.y < -0.25 {
            //                newOffset.y = self.frame.size.height * (newValue.y + 0.25)
            //            }
            //            else if newOffset.y > 0.25 {
            //                newOffset.y = (self.frame.size.height * (newValue.y - 0.25)) + (self.imageView.frame.size.height - self.frame.size.height)
            //            }
            //            else {
            //                newOffset.y = ((newOffset.y - 0.25) * (self.imageView.frame.size.height - self.frame.size.height))
            //            }
            
            //            newOffset.y = self.frame.size.height * (newValue.y)
            
//            newOffset.y = (newValue.y * imageView.frame.size.height) + (imageView.frame.size.height - self.frame.size.height)
            
            super.contentOffset = newOffset
        }
    }
    
    override var frame:CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
//            self.setImageViewFrame()
        }
    }
    
    var imageHeight:CGFloat{
        get{
            var cHeight:CGFloat = 0
            if self.imageView.image != nil {
                cHeight = self.imageView.image!.size.height
            }
            
            return cHeight
        }
    }
    
    var upperBounds:CGSize{
        get{
            let uBounds = CGSizeMake(self.frame.size.width * 1.5, self.frame.size.height * 2)
            return uBounds
        }
    }
    
    var lowerBounds:CGSize{
        get{
            let uBounds = CGSizeMake(self.frame.size.width, self.frame.size.height * 1.5)
            return uBounds
        }
    }
    
//    override init() {
//        super.init()
//        //        println("scroll view init")
//        self.setup()
//        //        self.backgroundColor = UIColor.blueColor()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        println("scroll view init with frame")
        self.setup()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func setup(){
        self.userInteractionEnabled = false
        self.autoresizesSubviews = true
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
        
        self.setupImageView()
    }
    
    func setupImageView() {
        
        self.imageView.clipsToBounds = false
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
//        self.setImageViewFrame()
        if !self.imageView.isDescendantOfView(self) {
            self.addSubview(self.imageView)
        }
        
    }
    
    
    
    
}


