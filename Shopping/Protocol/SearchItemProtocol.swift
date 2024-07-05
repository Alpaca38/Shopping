//
//  SearchItemProtocol.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import Foundation
import RealmSwift

protocol SearchItemProtocol {
    var title: String { get }
    var link: String { get }
    var image: String { get }
    var mallName: String { get }
    var productId: String { get }
    var lprice: String { get }
    
    var priceString: String { get }
}
