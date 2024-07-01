//
//  EmptyMainView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit

final class EmptyMainView: BaseView {
    lazy var searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.addSubview(bar)
        return bar
    }()
    
    private lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Image.empty
        self.addSubview(view)
        return view
    }()
    
    private lazy var emptyLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        label.textAlignment = .center
        label.text = "최근 검색어가 없어요"
        self.addSubview(label)
        return label
    }()
    
    override func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(self.snp.width).multipliedBy(0.7)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
       
    }
}
