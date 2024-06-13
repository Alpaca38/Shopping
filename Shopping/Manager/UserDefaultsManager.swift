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
        case isLogin
    }
    
    var isLogin: Bool {
        get {
            return userDefaults.bool(forKey: "isLogin")
        }
        
        set {
            userDefaults.set(newValue, forKey: "isLogin")
        }
    }
    
}
