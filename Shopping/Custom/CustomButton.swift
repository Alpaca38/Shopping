//
//  CustomButton.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit
import SnapKit
final class CustomButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: Font.boldTitle]), for: .normal)
        self.setTitleColor(Color.white, for: .normal)
        self.titleLabel?.font = Font.boldContent
        self.clipsToBounds = true
        self.layer.cornerRadius = Button.radius
        self.backgroundColor = Color.main
        
        self.snp.makeConstraints {
            $0.height.equalTo(Button.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
