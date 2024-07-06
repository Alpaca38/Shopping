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
}
