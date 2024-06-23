//
//  profileImageCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileImageCell: UICollectionViewCell {
    
    lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.inActive, borderColor: Color.lightGray, cornerRadius: Image.Size.smallProfile / 2, alpha: Image.Alpha.inActive)
        self.contentView.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(index: Int) {
        profileImageView.image = Image.Profile.allCases[index].profileImage
        
        if index == UserDefaultsManager.user.image {
            profileImageView.layer.borderWidth = Image.Border.active
            profileImageView.layer.borderColor = Color.main.cgColor
            profileImageView.alpha = Image.Alpha.active
        } else {
            profileImageView.layer.borderWidth = Image.Border.inActive
            profileImageView.layer.borderColor = Color.lightGray.cgColor
            profileImageView.alpha = Image.Alpha.inActive
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
