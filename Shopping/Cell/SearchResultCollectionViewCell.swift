//
//  SearchResultCollectionViewCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    var delegate: SearchResultCollectionViewCellDelegate?
    
    private lazy var imageView = {
        let view = UIImageView()
        view.isSkeletonable = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var mallLabel = {
        let view = UILabel()
        view.isSkeletonable = true
        view.font = Font.small
        view.textColor = Color.lightGray
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = Font.item
        label.numberOfLines = 2
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var priceLabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = Font.boldTitle
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var likeButton = {
        let button = UIButton()
        button.isSkeletonable = true
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
    }
    
    override func configureLayout() {
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
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(imageView).inset(16)
            $0.size.equalTo(30)
        }
        
    }
    
    func configure(data: SearchItemProtocol) {
        let url = URL(string: data.image)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        
        mallLabel.text = data.mallName
        
        titleLabel.attributedText = data.title.asAttributedString()
        
        priceLabel.text = data.priceString
        
        if UserDefaultsManager.likeList.contains(data.productId) {
            likeButton.setImage(Image.likeSelected, for: .normal)
            likeButton.backgroundColor = Color.white
        } else {
            likeButton.setImage(Image.likeUnSelected, for: .normal)
            likeButton.backgroundColor = Color.black.withAlphaComponent(0.15)
        }
        
    }
}

private extension SearchResultCollectionViewCell {
    @objc func likeButtonTapped(_ sender: UIButton) {
        delegate?.didLikeButtonTapped(cell: self)
    }
}
