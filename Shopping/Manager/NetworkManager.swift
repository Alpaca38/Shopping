//
//  NetworkManager.swift
//  Shopping
//
//  Created by 조규연 on 6/20/24.
//

import Foundation
import Alamofire

class NetworkManager {
    private init() { }
    static let shared = NetworkManager()
    
    func getShoppingData(query: String, sort: Sort.RawValue, page: Int, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        
        let parameters: Parameters = [
            "query": query,
            "start": page,
            "display": 30,
            "sort": sort
        ]
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        // success와 failure의 기준은 http status code를 기준으로
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: header)
        .validate()
        .responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
