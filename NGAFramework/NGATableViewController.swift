//
//  NGATableView.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

class NGATableViewController: NGAViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView:UITableView = {
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
    
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tableView.delegate = nil
//        self.tableView.dataSource = nil
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
        self.setTableViewFrame()
        
    }
    
    func setTableViewFrame() {
        self.tableView.frame = self.contentView.bounds
        if !self.tableView.isDescendantOfView(self.contentView){
            self.contentView.addSubview(self.tableView)
        }
//        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.contentView.bounds.size.height * 0.1
    }

    
    
    
}
