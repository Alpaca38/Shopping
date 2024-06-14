//
//  SearchTableViewCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    lazy var clockImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Color.black
        view.image = Image.clock
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var contentLabel = {
        let label = UILabel()
        label.font = Font.item
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var xImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Color.black
        view.image = Image.xmark
        self.contentView.addSubview(view)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    func configureLayout() {
        clockImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(contentLabel.snp.height)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(clockImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        xImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(contentLabel.snp.height)
        }
    }
    
    func configure(index: Int) {
        contentLabel.text = UserDefaultsManager.standard.searchList[index]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
