//
//  NaverShoppingAPI.swift
//  Shopping
//
//  Created by 조규연 on 6/26/24.
//

import Foundation
import Alamofire

enum NaverAPI {
    case searchShop(query: String, page: Int, sort: Sort.RawValue)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/"
    }
    
    var endpoint: URL? {
        switch self {
        case .searchShop:
            return URL(string: baseURL + "search/shop.json")
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .searchShop(let query, let page, let sort):
            return ["query": query, "start": page, "display": 30, "sort": sort]
        }
    }
    
    var header: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchShop:
            return .get
        }
    }
}
