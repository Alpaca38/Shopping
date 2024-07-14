//
//  SearchViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/14/24.
//

import Foundation

final class SearchViewModel {
    var outputList: Observable<[String]> = Observable([])
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.outputList.value = UserDefaultsManager.searchList
        }
    }
}
