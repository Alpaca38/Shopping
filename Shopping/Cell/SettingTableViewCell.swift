//
//  SettingTableViewCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    lazy var titleLabel = {
        let label = UILabel()
        label.font = Font.content
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var subTitleLabel = {
        let label = UILabel()
        label.font = Font.content
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var likeImage = {
        let view = UIImageView()
        self.contentView.addSubview(view)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        selectionStyle = .none
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        likeImage.snp.makeConstraints {
            $0.trailing.equalTo(subTitleLabel.snp.leading).offset(-2)
            $0.centerY.equalTo(subTitleLabel)
            $0.size.equalTo(20)
        }
    }
    
    func configure(index: Int) {
        titleLabel.text = SettingOptions.allCases[index].rawValue
        if index == 0 {
            subTitleLabel.text = "\(UserDefaultsManager.standard.likeList.count)개의 상품"
            likeImage.image = Image.likeSelected
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
