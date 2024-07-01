//
//  NetworkManager.swift
//  Shopping
//
//  Created by 조규연 on 6/20/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    private init() { }
    static let shared = NetworkManager()
    
    func getNaverAPI<T: Decodable>(api: NaverAPI, responseType: T.Type, completion: @escaping(Result<T, APIError>) -> Void ) {
        guard let url = api.endpoint else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameter,
                   headers: api.header)
        .validate()
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(_):
                switch response.response?.statusCode {
                case 400:
                    completion(.failure(.invalidRequestVariables))
                case 401:
                    completion(.failure(.failedAuthentication))
                case 403:
                    completion(.failure(.invalidReauest))
                case 404:
                    completion(.failure(.invalidURL))
                case 405:
                    completion(.failure(.invalidMethod))
                case 408:
                    completion(.failure(.networkDelay))
                case 429:
                    completion(.failure(.requestLimit))
                case 500:
                    completion(.failure(.serverError))
                default:
                    print("Network Error")
                }
            }
        }
    }
    
    func getNaverAPIURLSession<T: Decodable>(urlComponent: URLComponent, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) {
        var component = URLComponents()
        component.scheme = urlComponent.scheme
        component.host = urlComponent.host
        component.path = urlComponent.path
        component.queryItems = urlComponent.queryItems
        guard let url = component.url else { return }
        do {
            let request = try URLRequest(url: url, method: .get, headers: urlComponent.headers)
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        completion(.failure(.failedRequest))
                        return
                    }
                    guard let data else {
                        completion(.failure(.noData))
                        return
                    }
                    guard let response = response as? HTTPURLResponse else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    guard response.statusCode == 200 else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(.invalidReauest))
        }
        
    }
}
