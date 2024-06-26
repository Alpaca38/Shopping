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
    
    func getNaverAPI<T: Decodable>(api: NaverAPI, responseType: T.Type, completion: @escaping(Result<T, Error>) -> Void ) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   headers: api.header)
        .validate()
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
