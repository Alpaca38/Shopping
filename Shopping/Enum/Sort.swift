//
//  Sort.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

enum Sort: String, CaseIterable {
    case sim // 정확도순으로 내림차순 (기본값)
    case date // 날짜순 내림차순
    case dsc // 가격 높은순
    case asc // 가격 낮은순
    
    var sortString: String {
        switch self {
        case .sim:
            return "  정확도  "
        case .date:
            return "  날짜순  "
        case .dsc:
            return "  가격높은순  "
        case .asc:
            return "  가격낮은순  "
        }
    }
}
