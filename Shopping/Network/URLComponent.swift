//
//  URLComponent.swift
//  Shopping
//
//  Created by 조규연 on 6/27/24.
//

import Foundation
import Alamofire

enum URLComponent {
    case searchShop(query: String, page: Int, sort: Sort.RawValue)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        switch self {
        case .searchShop:
            return "openapi.naver.com"
        }
    }
    
    var path: String {
        switch self {
        case .searchShop:
            return "/v1/search/shop.json"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchShop(let query, let page, let sort):
            return [URLQueryItem(name: "query", value: query),
             URLQueryItem(name: "start", value: "\(page)"),
             URLQueryItem(name: "display", value: "30"),
             URLQueryItem(name: "sort", value: sort)]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .searchShop:
            return [
                "X-Naver-Client-Id": APIKey.naverId,
                "X-Naver-Client-Secret": APIKey.naverSecret
            ]
        }
    }
}
