//
//  UserDefaultsManager.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import Foundation

class UserDefaultsManager {
    private init() { }
    
    static let standard = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case isLogin, user, searchList, likeList
    }
    
    var isLogin: Bool {
        get {
            return userDefaults.bool(forKey: Key.isLogin.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.isLogin.rawValue)
        }
    }
    
    var user: User {
        get {
            if let savedData = UserDefaults.standard.object(forKey: Key.user.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(User.self, from: savedData) {
                    return lodedObejct
                }
            }
            let random = Int.random(in: 0..<Image.Profile.allCases.count)
            return User(image: Image.Profile.allCases[random].rawValue)
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: Key.user.rawValue)
            }
        }
    }
    
    var searchList : [String] {
        get {
            return userDefaults.stringArray(forKey: Key.searchList.rawValue) ?? []
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.searchList.rawValue)
        }
    }
    
    var likeList: [String] {
        get {
            return userDefaults.stringArray(forKey: Key.likeList.rawValue) ?? []
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.likeList.rawValue)
        }
    }
}
