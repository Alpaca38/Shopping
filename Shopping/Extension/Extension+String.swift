//
//  String.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import Foundation

extension String {
    func asAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
    }
}
