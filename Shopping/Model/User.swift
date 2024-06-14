//
//  User.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

struct User: Codable {
    var nickname: String = "옹골찬 고래밥"
    var image: Image.Profile.RawValue // Int
    
    var mainNaviTitle: String {
        return "\(nickname)'s Meaning Out"
    }
}
