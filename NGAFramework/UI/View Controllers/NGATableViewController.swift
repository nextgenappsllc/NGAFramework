//
//  NGATableView.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGATableViewController: NGAViewController, UITableViewDataSource, UITableViewDelegate {
    
    open lazy var tableView:UITableView = {
        let tempTableView:UITableView = UITableView(frame: self.contentView.bounds, style: UITableViewStyle.plain)
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tempTableView.backgroundColor = UIColor.white
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
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        self.setTableViewFrame()
        
    }
    
    open func setTableViewFrame() {
        self.tableView.frame = self.contentView.bounds
        if !self.tableView.isDescendant(of: self.contentView){
            self.contentView.addSubview(self.tableView)
        }
//        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
    }
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.contentView.bounds.size.height * 0.1
    }

    
    
    
}
