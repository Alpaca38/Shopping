//
//  SearchTableViewCell.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    
//    weak var delegate: SearchTableViewCellDelegate?
    var didXmarkTapped: (() -> Void)?
    
    private lazy var clockImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Color.black
        view.image = Image.clock
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var contentLabel = {
        let label = UILabel()
        label.font = Font.item
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var xImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Color.black
        view.image = Image.xmark
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        self.contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
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
        contentLabel.text = UserDefaultsManager.searchList[index]
    }
}

private extension SearchTableViewCell {
    @objc func xmarkTapped() {
        UserDefaultsManager.searchList.removeAll { $0 == contentLabel.text }
//        delegate?.didXMarkTapped()
        didXmarkTapped?()
    }
}
