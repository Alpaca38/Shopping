//
//  SearchResultViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/14/24.
//

import Foundation

final class SearchResultViewModel {
    var sendValidationError: ((ShoppingQueryError) -> Void)?
    var sendNetworkError: ((Result<SearchShoppingResult, APIError>) -> Void)?
    
    var outputList: Observable<SearchShoppingResult?> = Observable(nil)
    
    var inputSearchText: Observable<String?> = Observable(nil)
    var inputPage: Observable<Int> = Observable(1)
    var inputButtonIndex = Observable(0)
    
    init() {
        inputSearchText.bind { [weak self] searchText in
            self?.validate(searchText: searchText)
        }
        
        inputPage.bind(false) { [weak self] page in
            guard let self else { return }
            getShoppingDataURLSession(searchText: inputSearchText.value, sort: Sort.allCases[inputButtonIndex.value].rawValue)
        }
    }
    
    private func validate(searchText: String?) {
        do {
            guard let searchText else { return }
            let _ = try validateQuery(query: searchText)
            getShoppingDataURLSession(searchText: searchText, sort: Sort.sim.rawValue)
        } catch ShoppingQueryError.whitespace {
            sendValidationError?(.whitespace)
        } catch ShoppingQueryError.specialCharacter {
            sendValidationError?(.specialCharacter)
        } catch {
            
        }
    }
    
    private func validateQuery(query: String) throws -> Bool {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            throw ShoppingQueryError.whitespace
        }
        guard !query.contains(where: { LiteralString.allSpecialCharacter.contains($0) }) else {
            throw ShoppingQueryError.specialCharacter
        }
        return true
    }
    
    private func getShoppingDataURLSession(searchText: String?, sort: Sort.RawValue) {
        guard let searchText else { return }
        NetworkManager.shared.getNaverAPIURLSession(urlComponent: .searchShop(query: searchText, page: inputPage.value, sort: sort), responseType: SearchShoppingResult.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                sendNetworkError?(.success(success))
            case .failure(let failure):
                sendNetworkError?(.failure(failure))
            }
        }
    }
}