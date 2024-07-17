//
//  SearchResultViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/14/24.
//

import Foundation

final class SearchResultViewModel {
    private let repository = SearchItemRepository()
    var sendValidationError: ((ShoppingQueryError) -> Void)?
    
    var outputList: Observable<SearchShoppingResult?> = Observable(nil)
    var outputNetworkSuccess = Observable<Void?>(nil)
    var outputNetworkError = Observable<APIError?>(nil)
    
    var inputSearchText: Observable<String?> = Observable(nil)
    var inputPage: Observable<Int> = Observable(1)
    var inputButtonIndex = Observable(0)
    var inputLike = Observable<SearchItemDTO?>(nil)
    var inputUnLike = Observable<SearchItem?>(nil)
    
    init() {
        inputSearchText.bind { [weak self] searchText in
            self?.validate(searchText: searchText)
        }
        
        inputPage.bind(false) { [weak self] page in
            guard let self else { return }
            getShoppingDataURLSession(searchText: inputSearchText.value, sort: Sort.allCases[inputButtonIndex.value].rawValue)
        }
        
        inputLike.bind { [weak self] data in
            guard let data else { return }
            self?.repository.createItem(data: data)
        }
        
        inputUnLike.bind { [weak self] item in
            guard let self, let item else { return }
            if let data = repository.fetchItemFromProduct(productID: item.productId) {
                repository.deleteItem(data: data)
            }
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
                if inputPage.value == 1 {
                    outputList.value = success
                    if !outputList.value!.items.isEmpty {
                        outputNetworkSuccess.value = ()
                    }
                } else {
                    outputList.value?.items.append(contentsOf: success.items)
                }
            case .failure(let failure):
                outputNetworkError.value = failure
            }
        }
    }
}
