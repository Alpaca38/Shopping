//
//  SearchResult.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

struct SearchShoppingResult: Decodable {
    let lastBuildDate: String
    let total, start, display: Int
    var items: [SearchItem]
    
    var totalString: String {
        return "\(total.formatted())개의 검색 결과"
    }
}

struct SearchItem: Decodable, SearchItemProtocol {
    let title: String
    let link: String
    let image: String
    let mallName: String
    let productId: String
    let lprice: String
    
    var priceString: String {
        let formattedPrice = Int(lprice)!.formatted()
        return formattedPrice + "원"
    }
    
    func toDTO() -> SearchItemDTO {
            let dto = SearchItemDTO()
            dto.title = self.title
            dto.link = self.link
            dto.image = self.image
            dto.mallName = self.mallName
            dto.productId = self.productId
            dto.lprice = self.lprice
            return dto
        }
}
