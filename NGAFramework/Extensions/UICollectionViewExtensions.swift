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
    public func registerCellClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forCellWithReuseIdentifier: key)
        }
    }
    public func registerHeaderClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: key)
        }
    }
    public func registerFooterClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: key)
        }
    }
    public func rectForCellAtIndexPath(_ indexPath:IndexPath) -> CGRect? {
        return layoutAttributesForItem(at: indexPath)?.frame
    }
}
