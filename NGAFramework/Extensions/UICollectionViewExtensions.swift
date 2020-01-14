//
//  UICollectionViewExtensions.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/31/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


extension UICollectionView {
    func registerCellClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forCellWithReuseIdentifier: key)
        }
    }
    func registerHeaderClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: key)
        }
    }
    func registerFooterClasses(_ dict:[String:AnyClass]) {
        for (key, value) in dict {
            register(value, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: key)
        }
    }
    func rectForCellAtIndexPath(_ indexPath:IndexPath) -> CGRect? {
        return layoutAttributesForItem(at: indexPath)?.frame
    }
}
