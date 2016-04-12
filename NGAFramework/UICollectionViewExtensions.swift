//
//  UICollectionViewExtensions.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/31/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


public extension UICollectionView {
    public func registerCellClasses(dict:[String:AnyClass]) {
        for (key, value) in dict {
            registerClass(value, forCellWithReuseIdentifier: key)
        }
    }
    public func registerHeaderClasses(dict:[String:AnyClass]) {
        for (key, value) in dict {
            registerClass(value, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: key)
        }
    }
    public func registerFooterClasses(dict:[String:AnyClass]) {
        for (key, value) in dict {
            registerClass(value, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: key)
        }
    }
    public func rectForCellAtIndexPath(indexPath:NSIndexPath) -> CGRect? {
        return layoutAttributesForItemAtIndexPath(indexPath)?.frame
    }
}