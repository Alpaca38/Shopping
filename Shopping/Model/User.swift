//
//  User.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

struct User: Codable {
    var nickname: String = ""
    var image: Image.Profile.RawValue // Int
    var registerDate: Date = Date()
    
    var mainNaviTitle: String {
        return "\(nickname)'s MEANING OUT"
    }
    
    var registerDateString: String {
        let formattedDate = registerDate.formatted(
            .dateTime.year()
            .month(.twoDigits)
            .day(.twoDigits)
            .locale(Locale(identifier: "ko_KR"))
        )
        return "\(formattedDate) 가입"
    }
}
