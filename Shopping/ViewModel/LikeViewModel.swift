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
    var outputObserveError = Observable<String?>(nil)
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputSearchText: Observable<String?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            outputList.value = repository.fetchAll()
            observeFolders()
        }
        
        inputSearchText.bind { [weak self] text in
            guard let self, let text else { return }
            let filter = repository.fetchSearchItem(text)
            let result = text.isEmpty ? repository.fetchAll() : filter
            outputList.value = result
        }
    }
    
    private func observeFolders() {
        repository.observeFolders { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial(let result):
                outputList.value = Array(result)
            case .update(let result, deletions: _, insertions: _, modifications: _):
                outputList.value = Array(result)
            case .error(let error):
                outputObserveError.value = error.localizedDescription
            }
        }
    }
}
