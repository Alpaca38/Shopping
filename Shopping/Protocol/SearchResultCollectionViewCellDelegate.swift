//
//  SearchResultCollectionViewCellDelegate.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

protocol SearchResultCollectionViewCellDelegate: AnyObject {
    func didLikeButtonTapped(cell: UICollectionViewCell)
}
