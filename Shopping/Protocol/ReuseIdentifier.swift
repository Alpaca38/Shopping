//
//  ReuseIdentifier.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

protocol ReuseIdentifier: AnyObject {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
