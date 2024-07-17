//
//  UserDefaultsManager.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import Foundation

final class UserDefaultsManager {
    private init() { }

    @UserDefault(key: .isLogin, defaultValue: false, isCustomObject: false)
    static var isLogin: Bool
    
    @UserDefault(key: .user, defaultValue: User(image: Image.Profile.allCases[Int.random(in: 0..<Image.Profile.allCases.count)].rawValue), isCustomObject: true)
    static var user: User
    
    @UserDefault(key: .searchList, defaultValue: [], isCustomObject: false)
    static var searchList: [String]
    
    @UserDefault(key: .likeList, defaultValue: Set<String>(), isCustomObject: true)
    static var likeList: Set<String>
}
