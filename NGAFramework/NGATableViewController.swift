//
//  NGATableView.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGATableViewController: NGAViewController, UITableViewDataSource, UITableViewDelegate {
    
    public lazy var tableView:UITableView = {
        let tempTableView:UITableView = UITableView(frame: self.contentView.bounds, style: UITableViewStyle.Plain)
        tempTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tempTableView.backgroundColor = UIColor.whiteColor()
        tempTableView.autoresizesSubviews = true
        //// if iOS 9
        if #available(iOS 9.0, *) {
            tempTableView.cellLayoutMarginsFollowReadableWidth = false
        }
//        tempTableView.cellLayoutMarginsFollowReadableWidth = false
//        tempTableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        return tempTableView
        }()
    

    
    //MARK: Frames
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        self.setTableViewFrame()
        
    }
    
    public func setTableViewFrame() {
        self.tableView.frame = self.contentView.bounds
        if !self.tableView.isDescendantOfView(self.contentView){
            self.contentView.addSubview(self.tableView)
        }
//        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.contentView.bounds.size.height * 0.1
    }

    
    
    
}
