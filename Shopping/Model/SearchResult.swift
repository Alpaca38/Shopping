//
//  SearchResult.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

struct SearchResult: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    var items: [Item]
    
    var totalString: String {
        return "\(total.formatted())개의 검색 결과"
    }
}

struct Item: Codable {
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
}
