//
//  SearchItemRepository.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import Foundation
import RealmSwift

final class SearchItemRepository {
    private let realm = try! Realm()
    private var notificationToken: NotificationToken?
    
    func createItem(data: SearchItemDTO) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("CreateItem Error")
        }
    }
    
    func fetchAll() -> [SearchItemDTO] {
        let results = realm.objects(SearchItemDTO.self)
        return Array(results)
    }
    
    func fetchItemFromProduct(productID: String) -> SearchItemDTO? {
        return realm.objects(SearchItemDTO.self).where {
            $0.productId == productID
        }.first
    }
    
    func fetchSearchItem(_ searchText: String) -> [SearchItemDTO] {
        let results = realm.objects(SearchItemDTO.self).where {
            $0.title.contains(searchText, options: .caseInsensitive)
        }
        return Array(results)
    }
    
    func deleteItem(data: SearchItemDTO) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("DeleteItem Error")
        }
    }
    
    func printRealmURL() {
        print(realm.configuration.fileURL!)
    }
    
    func observeFolders(completion: @escaping (RealmCollectionChange<Results<SearchItemDTO>>) -> Void) {
        let results = realm.objects(SearchItemDTO.self)
        notificationToken = results.observe { changes in
            switch changes {
            case .initial:
                completion(.initial(results))
            case .update(_, _, _, _):
                completion(.update(results, deletions: [], insertions: [], modifications: []))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}
