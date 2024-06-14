//
//  FilterButton.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class FilterButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: Font.content]), for: .normal)
        layer.borderColor = Color.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
