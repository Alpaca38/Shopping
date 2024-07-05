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
    
    func deleteItem(data: SearchItemDTO) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("DeleteItem Error")
        }
    }
}
