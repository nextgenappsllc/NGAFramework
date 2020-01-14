//
//  NGASwitchBarTableViewController.swift
//  MCMApp
//
//  Created by Jose Castellanos on 4/19/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


open class NGASwitchBarTableViewController: NGATableViewController, NGASwitchBarDelegate {
    
    open var switchBar = NGASwitchBar()
    
    open var switchBarIndex:Int {
        get {
            return self.switchBar.index
        }
    }
    
    open var switchBarRatio:CGFloat = 0.08 {didSet{DispatchQueue.main.async(execute: self.setFramesForSubviews)}}
    
    open var mainTableViewFrame:CGRect {
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
    
    
    
    //MARK: Setup
    open override func setup() {
        super.setup()
        self.contentView.isScrollEnabled = false
        self.switchBar.delegate = self
    }
    
    
    //MARK: Frames
    open override func setFramesForSubviews() {
        self.setSwitchBarFrame()
        super.setFramesForSubviews()
    }
    
    open func setSwitchBarFrame() {
        
        let longSide = self.contentView.longSide * switchBarRatio
        var switchBarFrame = self.contentView.bounds
        if landscape { switchBarFrame.size.width = longSide}
        else {switchBarFrame.size.height = longSide}
        self.switchBar.frame = switchBarFrame
        switchBar.vertical = landscape
        self.contentView.addSubview(switchBar)
    }
    
    open override func setTableViewFrame() {
        super.setTableViewFrame()
        self.tableView.frame = self.mainTableViewFrame
        
    }
    
    open func frameForTableview(_ tableView:UITableView) -> CGRect {
        let temp = CGRect.zero
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
    open func switchBarIndexChangedTo(_ index: Int) {
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
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.tableView.frame = endFrame1
            }, completion: { (completed:Bool) -> Void in
                self.tableView.reloadData()
                self.tableView.frame = startFrame2
                if self.tableView.numberOfSections > 0 && self.tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
                    
                }
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.tableView.frame = endFrame2
                    }, completion: { (completed:Bool) -> Void in
                        
                })
                
        }) 
    }
    
}
