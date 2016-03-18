//
//  NGAParallaxTableView.swift
//  
//
//  Created by Jose Castellanos on 4/5/15.
//
//

import Foundation
import UIKit

class NGAParallaxTableViewController: NGATableViewController {
    
    
    
    var refreshed = false
    var loadedMore = false
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NGAParallaxTableViewCell.self, forCellReuseIdentifier: "Cell")
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? NGAParallaxTableViewCell
        
        if cell == nil {
            cell = NGAParallaxTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
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
        //        return self.contentView.bounds.size.height * 0.5
        return self.tableView.frame.height * 0.5
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
                if let cell = cell as? NGAParallaxTableViewCell {
                    //                println("cell is nga cell")
                    let cellFrame = self.tableView.convertRect(cell.frame, toView: self.contentView)
                    //                var cellFrame = cell.frame
                    let yOrigin = cellFrame.origin.y
                    //                println("yOrigin = \(yOrigin) ")
                    
                    if yOrigin <= viewFrame.size.height && yOrigin >=  -cellFrame.size.height {
                        var newOffset = offset
                        if viewFrame.size.height > 0{
                            //                        println("cell origin \(cellFrame.origin.y) view origin \(viewFrame.origin.y)")
                            newOffset.y = (cellFrame.origin.y - viewFrame.origin.y) / viewFrame.size.height

                            cell.imageScrollView.contentOffset = newOffset
                            
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
//        print("load more")
    }
    
    func refresh() {
//        print("refresh")
    }
    
    
    
}










class NGAParallaxTableViewCell: UITableViewCell {
    
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
    var imageScrollView = NGAParallaxImageScrollView()
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
        self.customContentView.layer.cornerRadius = 10.0
        
        if !self.customContentView.isDescendantOfView(self.contentView) {
            self.contentView.addSubview(self.customContentView)
        }
        
        self.gradientImageView.contentMode = UIViewContentMode.ScaleToFill
        self.gradientImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.gradientImageView.image = UIImage(named: "Gradient.png")
        
        self.titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.shadowColor = UIColor.blackColor()
        self.titleLabel.shadowOffset = CGSizeMake(1, 1)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.autoresizesSubviews = true
        self.titleLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        
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
        let xInset:CGFloat = 10
        let yInset:CGFloat = 8
        var newFrame = self.bounds
        newFrame.origin = CGPointMake(newFrame.origin.x + xInset, newFrame.origin.y + yInset)
        newFrame.size = CGSizeMake(newFrame.size.width - (xInset * 2), newFrame.size.height - (yInset * 2))
        self.customContentView.frame = newFrame
    }
    func setFrameForGradientImageVIew(){
        self.gradientImageView.frame = self.customContentView.bounds
    }
    func setFrameForScrollView() {
        self.imageScrollView.frame = self.customContentView.bounds
    }
    func setFrameForTitleLabel() {
        let xInset:CGFloat = 5
        let yInset:CGFloat = self.customContentView.bounds.height / 2
        var newFrame = self.customContentView.bounds
        newFrame.origin = CGPointMake(newFrame.origin.x + xInset, newFrame.origin.y + yInset)
        newFrame.size = CGSizeMake(newFrame.size.width - (xInset * 2), newFrame.size.height - (yInset))
//        var newSize = self.customContentView.bounds.size
        
//        var newSize = self.titleLabel.sizeThatFits(newFrame.size)
//        newFrame.size = newSize
        newFrame.origin.y = self.customContentView.bounds.height - xInset - newFrame.size.height
        
        
        self.titleLabel.frame = newFrame
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








class NGAParallaxImageScrollView: UIScrollView {
    var imageView = UIImageView()
    
    weak var image:UIImage? {
        didSet{
            self.imageView.image = image
            self.setImageViewFrame()
        }
    }
    
    override var contentOffset:CGPoint {
        get{
            return super.contentOffset
        }
        set{
            var newOffset = newValue
            //            println("new value = \(newOffset.y)")
            newOffset.y = (newOffset.y * (self.imageView.frame.size.height - self.frame.size.height))
            //            println("image view height - frame height = \(self.imageView.frame.size.height - self.frame.size.height)")
            //            println("new offset = \(newOffset.y)")
            if newOffset.y < 0 {
                newOffset.y = (newValue.y * (self.frame.size.height))
            }
            super.contentOffset = newOffset
        }
    }
    
    override var frame:CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            self.setImageViewFrame()
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
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.setImageViewFrame()
        if !self.imageView.isDescendantOfView(self) {
            self.addSubview(self.imageView)
        }
        
    }
    
    func setImageViewFrame() {
        var newFrame = self.frame
        newFrame.origin = CGPointZero
        
        if self.imageView.image != nil {
            let imageSize = self.makeSizeForImageWith(self.imageView.image!.size, and: self.upperBounds, and: self.lowerBounds)
            newFrame.size = imageSize
            newFrame.origin.x = (self.frame.width - newFrame.size.width) / 2
        }
        
        self.imageView.frame = newFrame
        
        //        println("imageView frame = \(newFrame)")
        //        self.contentSize = self.imageView.frame.size
        
    }
    
    func makeSizeForImageWith(imageSize:CGSize, and upperBounds:CGSize, and lowerBounds:CGSize) ->CGSize {
        var finalSize = CGSizeZero
        var scale:CGFloat = 1.0
        let imagePortraitRatio = imageSize.height / imageSize.width
        let upperPortraitRatio = upperBounds.height / upperBounds.width
        let lowerPortraitRatio = lowerBounds.height / lowerBounds.width
        let portrait = imagePortraitRatio >= 1.0
        var inBetween = false
        if lowerPortraitRatio < upperPortraitRatio {
            if lowerPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= upperPortraitRatio {
                inBetween = true
            }
        }
        else {
            if upperPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= lowerPortraitRatio {
                inBetween = true
            }
        }
        if inBetween {
            //            println("in between")
            if portrait {
                if imageSize.height > upperBounds.height {
                    scale = upperBounds.height / imageSize.height
                }
                else if imageSize.width < lowerBounds.width {
                    scale = lowerBounds.width / imageSize.width
                }
                else {
                    
                }
            }
            else {
                if imageSize.width > upperBounds.width {
                    scale = upperBounds.width / imageSize.width
                }
                else if imageSize.height < lowerBounds.height {
                    scale = lowerBounds.height / imageSize.height
                }
                else {
                    
                }
            }
        }
        else {
            //            println("not in between")
            if portrait {
                //                println("portrait")
                scale = lowerBounds.width / imageSize.width
            }
            else {
                //                println("lanscape")
                scale = lowerBounds.height / imageSize.height
                //                scale = lowerBounds.width / imageSize.width
            }
            
        }
        
        finalSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale)
        
        return finalSize
    }
    
    
    
}



//class NGAParallaxTableViewController: NGATableViewController {
//    
//    
//    
//    var refreshed = false
//    var loadedMore = false
//    
//    //MARK: View Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.registerClass(NGAParallaxTableViewCell.self, forCellReuseIdentifier: "Cell")
//        setup()
//        
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//    }
//    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//    }
//    
//    
//    //MARK: Setup
//    override func setup() {
//        super.setup()
//        
//        
//    }
//    
//    
//    //MARK: Frames
//    
//    override func setFramesForSubviews() {
//        super.setFramesForSubviews()
//        
//    }
//    
////    override func setTableViewFrame() {
////        super.setTableViewFrame()
////        var frame = self.contentView.bounds
////        frame.origin.y = frame.size.height * 0.1
////        frame.size.height = frame.size.height - frame.origin.y
////        self.tableView.frame = frame
////    }
//    
//    //MARK: TableView
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 0
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? NGAParallaxTableViewCell
//        
//        if cell == nil {
//            cell = NGAParallaxTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//        }
//        
//        
//        return cell!
//    }
//    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if landscape {
//            return self.tableView.frame.height
//        }
//        return self.tableView.frame.height * 0.5
//    }
//    
//    //MARK: scroll view
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView == self.tableView {
//            let viewFrame = self.contentView.bounds
////            let viewFrame = self.tableView.frame
//            var visibileCells = self.tableView.visibleCells()
//            var offset = scrollView.contentOffset
//            var yOffset = offset.y
//            var i = 0
//            for cell in visibileCells {
//                if cell is NGAParallaxTableViewCell {
//                    var cellFrame = self.tableView.convertRect(cell.frame, toView: self.contentView)
//                    var yOrigin = cellFrame.origin.y
//                    if yOrigin <= viewFrame.size.height && yOrigin >=  -cellFrame.size.height {
//                        var newOffset = offset
//                        
//                        if viewFrame.size.height > 0 {
//                            newOffset.y = (cellFrame.origin.y - viewFrame.origin.y) / viewFrame.size.height
//                            if cell.imageScrollView != nil {
//                                cell.imageScrollView!.contentOffset = newOffset
////                                cell.imageScrollView.imageView.frame = self.contentView.bounds
//                            }
//                        }
//                        
//                    }
//                }
//            }
//            
//            var distanceFromBottom = scrollView.contentSize.height - yOffset - viewFrame.size.height
//            var threshold = -viewFrame.size.height / 5
//            if distanceFromBottom < threshold {
//                if !self.loadedMore {
//                    self.loadedMore = true
//                    self.loadMore()
//                }
//                
//            }
//            else {
//                loadedMore = false
//            }
//            
//            if yOffset < threshold {
//                if !self.refreshed {
//                    self.refreshed = true
//                    self.refresh()
//                }
//                
//            }
//            else {
//                self.refreshed = false
//            }
//            
//        }
//        
//        
//        
//    }
//    
//    
//    //MARK: Scrolling Responders
//    func loadMore() {
//        
//    }
//    
//    func refresh() {
//        
//    }
//    
//    
//    
//}
//
//
//
//
//
//
//
//
//
//
//class NGAParallaxTableViewCell: UITableViewCell {
//    
//    var titleText:String? {
//        didSet {
//            self.titleLabel.text = titleText
//            self.setFrameForTitleLabel()
//        }
//    }
//    
//    weak var mainImage:UIImage? {
//        set {
//            self.imageScrollView.image = newValue
//        }
//        get {
//            return self.imageScrollView.image
//        }
//    }
//    
//    var customContentView = UIView()
//    var imageScrollView = NGAParallaxImageScrollView()
//    var gradientImageView = UIImageView()
//    var titleLabel = UILabel()
//    
//    override var frame:CGRect {
//        get {
//            return super.frame
//        }
//        set {
//            super.frame = newValue
//            self.setFrames()
//        }
//    }
//    
//    convenience required init(coder aDecoder: NSCoder) {
//        self.init()
//    }
//    
//    override init() {
//        super.init()
//        self.setup()
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.setup()
//    }
//    
//    func setup(){
//        
//        self.autoresizesSubviews = true
//        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
//        self.contentView.backgroundColor = UIColor.clearColor()
//        self.backgroundColor = UIColor.clearColor()
//        
//        self.contentView.contentMode = UIViewContentMode.ScaleAspectFill
//        self.contentView.autoresizesSubviews = true
//        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
//        self.customContentView.contentMode = UIViewContentMode.ScaleAspectFill
//        self.customContentView.autoresizesSubviews = true
//        self.customContentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        self.customContentView.clipsToBounds = true
//        //        self.customContentView.layer.cornerRadius = 10.0
//        
//        if !self.customContentView.isDescendantOfView(self.contentView) {
//            self.contentView.addSubview(self.customContentView)
//        }
//        
//        self.gradientImageView.contentMode = UIViewContentMode.ScaleToFill
//        self.gradientImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        self.gradientImageView.image = UIImage(named: "Gradient.png")
//        
//        self.titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)
//        self.titleLabel.textColor = UIColor.whiteColor()
//        self.titleLabel.shadowColor = UIColor.blackColor()
//        self.titleLabel.shadowOffset = CGSizeMake(1, 1)
//        self.titleLabel.numberOfLines = 0
//        self.titleLabel.autoresizesSubviews = true
//        self.titleLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
//        
//        self.setFrames()
//        
//    }
//    
//    func setFrames(){
//        self.setFrameForCustomContentView()
//        if !self.customContentView.isDescendantOfView(self.contentView) {
//            self.contentView.addSubview(self.customContentView)
//        }
//        
//        self.setFrameForScrollView()
//        if !self.imageScrollView.isDescendantOfView(self.customContentView) {
//            self.customContentView.addSubview(self.imageScrollView)
//        }
//        
//        self.setFrameForGradientImageVIew()
//        if !self.gradientImageView.isDescendantOfView(self.customContentView) {
//            self.customContentView.addSubview(self.gradientImageView)
//        }
//        
//        self.setFrameForTitleLabel()
//        if !self.titleLabel.isDescendantOfView(self.customContentView) {
//            self.customContentView.addSubview(self.titleLabel)
//        }
//    }
//    
//    func setFrameForCustomContentView(){
//        var xInset:CGFloat = 10
//        var yInset:CGFloat = 8
//        var newFrame = self.bounds
//        
//        newFrame.origin = CGPointMake(newFrame.origin.x + xInset, newFrame.origin.y + yInset)
//        newFrame.size = CGSizeMake(newFrame.size.width - (xInset * 2), newFrame.size.height - (yInset * 2))
//        self.customContentView.frame = newFrame
//    }
//    func setFrameForGradientImageVIew(){
//        self.gradientImageView.frame = self.customContentView.bounds
//    }
//    func setFrameForScrollView() {
//        self.imageScrollView.frame = self.customContentView.bounds
//    }
//    func setFrameForTitleLabel() {
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
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.imageScrollView.image = nil
//    }
//    
//    func removeAllSubViews() {
//        for view in self.contentView.subviews as [UIView]{
//            view.removeFromSuperview()
//        }
//    }
//    
//    
//}
//
//
//
//class NGAParallaxImageScrollView: UIScrollView {
//    var imageView = UIImageView()
//    
//    weak var image:UIImage? {
//        didSet{
//            self.imageView.image = image
//            self.setImageViewFrame()
//        }
//    }
//    
//    override var contentOffset:CGPoint {
//        get{
//            return super.contentOffset
//        }
//        set{
//            var newOffset = newValue
//            newOffset.y = -(newOffset.y * (self.imageView.frame.size.height - (self.frame.size.height * 2)))
////            newOffset.y = (newOffset.y * (self.imageView.frame.size.height - (self.frame.size.height)))
////            if newOffset.y < 0 {
////                newOffset.y = (newValue.y * (self.frame.size.height))
////            }
////            else if newOffset.y > 1 {
////                newOffset.y = self.imageView.frame.size.height - self.frame.size.height
////            }
////            else {
////                
////            }
//            super.contentOffset = newOffset
//        }
//    }
//    
//    override var frame:CGRect {
//        get {
//            return super.frame
//        }
//        set {
//            super.frame = newValue
//            self.setImageViewFrame()
//        }
//    }
//    
//    var imageHeight:CGFloat{
//        get{
//            var cHeight:CGFloat = 0
//            if self.imageView.image != nil {
//                cHeight = self.imageView.image!.size.height
//            }
//            
//            return cHeight
//        }
//    }
//    
//    var upperBounds:CGSize{
//        get{
//            var uBounds = CGSizeMake(self.frame.size.width * 1.5, self.frame.size.height * 2)
//            return uBounds
//        }
//    }
//    
//    var lowerBounds:CGSize{
//        get{
//            var uBounds = CGSizeMake(self.frame.size.width, self.frame.size.height * 1.5)
//            return uBounds
//        }
//    }
//    
//    override init() {
//        super.init()
//        self.setup()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setup()
//    }
//    
//    convenience required init(coder aDecoder: NSCoder) {
//        self.init()
//    }
//    
//    func setup(){
//        self.userInteractionEnabled = false
//        self.autoresizesSubviews = true
//        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        self.clipsToBounds = false
//        self.backgroundColor = UIColor.clearColor()
//        
//        self.setupImageView()
//    }
//    
//    func setupImageView() {
//        
//        self.imageView.clipsToBounds = false
//        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        self.imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
//        self.setImageViewFrame()
//        if !self.imageView.isDescendantOfView(self) {
//            self.addSubview(self.imageView)
//        }
//        
//    }
//    
//    func setImageViewFrame() {
//        var newFrame = self.frame
//        newFrame.origin = CGPointZero
//        
//        if self.imageView.image != nil {
//            var imageSize = self.makeSizeForImageWith(self.imageView.image!.size, and: self.upperBounds, and: self.lowerBounds)
//            newFrame.size = imageSize
//            newFrame.origin.x = (self.frame.width - newFrame.size.width) / 2
//        }
//        
//        self.imageView.frame = newFrame
//        self.contentSize = self.imageView.frame.size
//        
//    }
//    
//    func makeSizeForImageWith(imageSize:CGSize, and upperBounds:CGSize, and lowerBounds:CGSize) ->CGSize {
//        var finalSize = CGSizeZero
//        var scale:CGFloat = 1.0
//        let imagePortraitRatio = imageSize.height / imageSize.width
//        let upperPortraitRatio = upperBounds.height / upperBounds.width
//        let lowerPortraitRatio = lowerBounds.height / lowerBounds.width
//        var portrait = imagePortraitRatio >= 1.0
//        var inBetween = false
//        if lowerPortraitRatio < upperPortraitRatio {
//            if lowerPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= upperPortraitRatio {
//                inBetween = true
//            }
//        }
//        else {
//            if upperPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= lowerPortraitRatio {
//                inBetween = true
//            }
//        }
//        if inBetween {
//            if portrait {
//                if imageSize.height > upperBounds.height {
//                    scale = upperBounds.height / imageSize.height
//                }
//                else if imageSize.width < lowerBounds.width {
//                    scale = lowerBounds.width / imageSize.width
//                }
//                else {
//                    
//                }
//            }
//            else {
//                if imageSize.width > upperBounds.width {
//                    scale = upperBounds.width / imageSize.width
//                }
//                else if imageSize.height < lowerBounds.height {
//                    scale = lowerBounds.height / imageSize.height
//                }
//                else {
//                    
//                }
//            }
//        }
//        else {
//            if portrait {
//                scale = lowerBounds.width / imageSize.width
//            }
//            else {
//                scale = lowerBounds.height / imageSize.height
//            }
//            
//        }
//        
//        finalSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale)
//        
//        return finalSize
//    }
//    
//    
//    
//}
//
//

//
//class NGAParallaxImageScrollView: UIScrollView {
//    var imageView = UIImageView()
//    
//    weak var image:UIImage? {
//        didSet{
//            self.imageView.image = image
//            self.setImageViewFrame()
//        }
//    }
//    
//    override var contentOffset:CGPoint {
//        get{
//            return super.contentOffset
//        }
//        set{
//            var newOffset = newValue
//            println("new value = \(newOffset.y)")
//            newOffset.y = (newOffset.y * (self.imageView.frame.size.height - (self.frame.size.height * 2)))
////            newOffset.y = (newOffset.y * (self.imageView.frame.size.height - (self.frame.size.height)))
//            //            println("image view height - frame height = \(self.imageView.frame.size.height - self.frame.size.height)")
//            println("new offset = \(newOffset.y)")
//            if newOffset.y < 0 {
//                //                newOffset.y = (newValue.y * (self.frame.size.height))
//                newOffset.y = 0
//            }
//            else if newOffset.y > 1 {
//                newOffset.y = self.imageView.frame.size.height - self.frame.size.height
//            }
//            else {
//                println("in between offset = \(newOffset.y)")
//            }
//            super.contentOffset = newOffset
//        }
//    }
//    
//    
//    override var frame:CGRect {
//        get {
//            return super.frame
//        }
//        set {
//            super.frame = newValue
//            self.setImageViewFrame()
//        }
//    }
//    
//    var imageHeight:CGFloat{
//        get{
//            var cHeight:CGFloat = 0
//            if self.imageView.image != nil {
//                cHeight = self.imageView.image!.size.height
//            }
//            
//            return cHeight
//        }
//    }
//    
//    var upperBounds:CGSize{
//        get{
//            var uBounds = CGSizeMake(self.frame.size.width * 1.5, self.frame.size.height * 2)
//            return uBounds
//        }
//    }
//    
//    var lowerBounds:CGSize{
//        get{
//            var uBounds = CGSizeMake(self.frame.size.width, self.frame.size.height * 1.5)
//            return uBounds
//        }
//    }
//    
//    override init() {
//        super.init()
//        //        println("scroll view init")
//        self.setup()
//        //        self.backgroundColor = UIColor.blueColor()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //        println("scroll view init with frame")
//        //        self.setup()
//    }
//    
//    convenience required init(coder aDecoder: NSCoder) {
//        self.init()
//    }
//    
//    func setup(){
//        self.userInteractionEnabled = false
//        self.autoresizesSubviews = true
//        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        self.clipsToBounds = false
//        self.backgroundColor = UIColor.clearColor()
//        
//        self.setupImageView()
//    }
//    
//    func setupImageView() {
//        
//        self.imageView.clipsToBounds = false
//        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        self.imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
//        self.setImageViewFrame()
//        if !self.imageView.isDescendantOfView(self) {
//            self.addSubview(self.imageView)
//        }
//        
//    }
//    
//    func setImageViewFrame() {
//        var newFrame = self.frame
//        newFrame.origin = CGPointZero
//        
//        if self.imageView.image != nil {
//            var imageSize = self.makeSizeForImageWith(self.imageView.image!.size, and: self.upperBounds, and: self.lowerBounds)
//            newFrame.size = imageSize
//            newFrame.origin.x = (self.frame.width - newFrame.size.width) / 2
//        }
//        
//        self.imageView.frame = newFrame
//        
//        //        println("imageView frame = \(newFrame)")
//                self.contentSize = self.imageView.frame.size
//        
//    }
//    
//    func makeSizeForImageWith(imageSize:CGSize, and upperBounds:CGSize, and lowerBounds:CGSize) ->CGSize {
//        var finalSize = CGSizeZero
//        var scale:CGFloat = 1.0
//        let imagePortraitRatio = imageSize.height / imageSize.width
//        let upperPortraitRatio = upperBounds.height / upperBounds.width
//        let lowerPortraitRatio = lowerBounds.height / lowerBounds.width
//        var portrait = imagePortraitRatio >= 1.0
//        var inBetween = false
//        if lowerPortraitRatio < upperPortraitRatio {
//            if lowerPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= upperPortraitRatio {
//                inBetween = true
//            }
//        }
//        else {
//            if upperPortraitRatio <= imagePortraitRatio && imagePortraitRatio <= lowerPortraitRatio {
//                inBetween = true
//            }
//        }
//        if inBetween {
//            //            println("in between")
//            if portrait {
//                if imageSize.height > upperBounds.height {
//                    scale = upperBounds.height / imageSize.height
//                }
//                else if imageSize.width < lowerBounds.width {
//                    scale = lowerBounds.width / imageSize.width
//                }
//                else {
//                    
//                }
//            }
//            else {
//                if imageSize.width > upperBounds.width {
//                    scale = upperBounds.width / imageSize.width
//                }
//                else if imageSize.height < lowerBounds.height {
//                    scale = lowerBounds.height / imageSize.height
//                }
//                else {
//                    
//                }
//            }
//        }
//        else {
//            //            println("not in between")
//            if portrait {
//                //                println("portrait")
//                scale = lowerBounds.width / imageSize.width
//            }
//            else {
//                //                println("lanscape")
//                scale = lowerBounds.height / imageSize.height
//                //                scale = lowerBounds.width / imageSize.width
//            }
//            
//        }
//        
//        finalSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale)
//        
//        return finalSize
//    }
//    
//    
//    
//}