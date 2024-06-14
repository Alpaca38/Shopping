//
//  SearchResultCollectionViewCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var mallLabel = {
        let view = UILabel()
        view.font = Font.small
        view.textColor = Color.lightGray
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var titleLabel = {
        let label = UILabel()
        label.font = Font.item
        label.numberOfLines = 2
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var priceLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.65)
        }
        
        mallLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(1)
            $0.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
    }
    
    func configure(data: Item) {
        let url = URL(string: data.image)
        imageView.kf.setImage(with: url)
        
        mallLabel.text = data.mallName
        
        titleLabel.attributedText = data.title.asAttributedString()
        
        priceLabel.text = data.priceString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
