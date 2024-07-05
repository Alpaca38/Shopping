//
//  LikeView.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import UIKit
import SnapKit

final class LikeView: BaseView {
    lazy var searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.addSubview(bar)
        return bar
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - sectionSpacing * 2
        layout.itemSize = CGSize(width: width, height: width * 2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}
