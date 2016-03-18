//
//  NGASwitchBarTableViewController.swift
//  MCMApp
//
//  Created by Jose Castellanos on 4/19/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


class NGASwitchBarTableViewController: NGATableViewController, NGASwitchBarDelegate {
    
    var switchBar = NGASwitchBar()
    
    var switchBarIndex:Int {
        get {
            return self.switchBar.index
        }
    }
    
    var switchBarRatio:CGFloat = 0.08 {didSet{dispatch_async(dispatch_get_main_queue(), self.setFramesForSubviews)}}
    
    var mainTableViewFrame:CGRect {
        get {
            let longSide = self.contentView.longSide * (1 - switchBarRatio)
            var tableViewFrame = self.contentView.bounds
            if landscape {
                tableViewFrame.size.width = longSide
                tableViewFrame.origin.x = self.contentView.bounds.size.width - tableViewFrame.size.width
            }
            else {
                tableViewFrame.size.height = longSide
                tableViewFrame.origin.y = self.contentView.bounds.size.height - tableViewFrame.size.height
            }
            return tableViewFrame
        }
    }
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tableView.delegate = nil
//        self.tableView.dataSource = nil
        
    }
    
    
    //MARK: Setup
    override func setup() {
        super.setup()
        self.contentView.scrollEnabled = false
        self.switchBar.delegate = self
    }
    
    
    //MARK: Frames
    override func setFramesForSubviews() {
        self.setSwitchBarFrame()
        super.setFramesForSubviews()
    }
    
    func setSwitchBarFrame() {
        
        let longSide = self.contentView.longSide * switchBarRatio
        var switchBarFrame = self.contentView.bounds
        if landscape {
            switchBarFrame.size.width = longSide
        }
        else {
            switchBarFrame.size.height = longSide
        }
        self.switchBar.frame = switchBarFrame
        switchBar.vertical = landscape
        self.contentView.addSubview(switchBar)
    }
    
    override func setTableViewFrame() {
        super.setTableViewFrame()
        self.tableView.frame = self.mainTableViewFrame
        
    }
    
    func frameForTableview(tableView:UITableView) -> CGRect {
        let temp = CGRectZero
        let longSide = self.contentView.longSide * 0.9
        var tableViewFrame = self.contentView.bounds
        if landscape {
            tableViewFrame.size.width = longSide
            tableViewFrame.origin.x = self.contentView.bounds.size.width - tableViewFrame.size.width
        }
        else {
            tableViewFrame.size.height = longSide
            tableViewFrame.origin.y = self.contentView.bounds.size.height - tableViewFrame.size.height
        }
        return temp
    }
    
    
    //MARK: Switch Bar Delegate
    func switchBarIndexChangedTo(index: Int) {
//        self.loadFoldersAndFilesInBackground()
        
        let startFrame1 = self.mainTableViewFrame
        var endFrame1 = startFrame1
        var startFrame2 = startFrame1
        let endFrame2 = startFrame1
        if landscape {
            endFrame1.origin.y = -endFrame1.size.height
            startFrame2.origin.y = endFrame1.size.height
        }
        else {
            endFrame1.origin.x = -endFrame1.size.width
            startFrame2.origin.x = endFrame1.size.width
        }
        
        
        if index == 0 {
            let temp1 = endFrame1
            endFrame1 = startFrame2
            startFrame2 = temp1
        }
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.tableView.frame = endFrame1
            }) { (completed:Bool) -> Void in
                self.tableView.reloadData()
                self.tableView.frame = startFrame2
                if self.tableView.numberOfSections > 0 && self.tableView.numberOfRowsInSection(0) > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                    
                }
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.tableView.frame = endFrame2
                    }, completion: { (completed:Bool) -> Void in
                        
                })
                
        }
    }
    
}