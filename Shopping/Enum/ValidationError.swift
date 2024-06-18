//
//  ValidationError.swift
//  Shopping
//
//  Created by 조규연 on 6/18/24.
//

import Foundation

enum ValidationError: Error {
    case includeSpecial
    case includeInt
    case isNotValidCount
}
