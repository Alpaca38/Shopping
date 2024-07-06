//
//  RealmModel.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import Foundation
import RealmSwift

final class SearchItemDTO: Object, SearchItemProtocol {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var productId: String
    @Persisted var lprice: String
    
    var priceString: String {
        let formattedPrice = Int(lprice)!.formatted()
        return formattedPrice + "원"
    }
    
    convenience init(id: ObjectId, title: String, link: String, image: String, mallName: String, productId: String, lprice: String) {
        self.init()
        self.title = title
        self.link = link
        self.image = image
        self.mallName = mallName
        self.productId = productId
        self.lprice = lprice
    }
    
    convenience init(from searchItem: SearchItem) {
            self.init()
            self.title = searchItem.title
            self.link = searchItem.link
            self.image = searchItem.image
            self.mallName = searchItem.mallName
            self.productId = searchItem.productId
            self.lprice = searchItem.lprice
        }
}
