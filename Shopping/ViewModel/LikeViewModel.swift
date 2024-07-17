//
//  LiveViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/14/24.
//

import Foundation

final class LikeViewModel {
    let repository = SearchItemRepository()
    var outputList: Observable<[SearchItemDTO]> = Observable([])
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputSearchText: Observable<String?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputList.value = repository.fetchAll()
        }
        
        inputSearchText.bind { [weak self] text in
            guard let self, let text else { return }
            let filter = repository.fetchSearchItem(text)
            let result = text.isEmpty ? repository.fetchAll() : filter
            outputList.value = result
        }
    }
}
