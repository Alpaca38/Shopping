//
//  SearchResultView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit
import SkeletonView

final class SearchResultView: BaseView {
    
    weak var delegate: SearchResultViewDelegate?
    private lazy var selectedButton = simButton
    var selectButtonIndex: Int = 0
    
    private lazy var totalLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        label.textColor = Color.main
        self.addSubview(label)
        return label
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.isSkeletonable = true
        view.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.addSubview(view)
        return view
    }()
    
    private lazy var simButton = {
        let button = FilterButton(title: Sort.sim.sortString)
        button.tag = 0
        button.backgroundColor = Color.darkGray
        button.setTitleColor(Color.white, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateButton = {
        let button = FilterButton(title: Sort.date.sortString)
        button.tag = 1
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dscButton = {
        let button = FilterButton(title: Sort.dsc.sortString)
        button.tag = 2
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var ascButton = {
        let button = FilterButton(title: Sort.asc.sortString)
        button.tag = 3
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterStackView = {
        let view = UIStackView(arrangedSubviews: [simButton, dateButton, dscButton, ascButton])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .leading
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    override func configureLayout() {
        totalLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(10)
            $0.leading.equalTo(totalLabel)
            $0.trailing.equalToSuperview().offset(-60)
            $0.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - sectionSpacing * 2 - cellSpacing
        layout.itemSize = CGSize(width: width/2, height: width/2 * 2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    func configure(data: SearchShoppingResult?) {
        totalLabel.text = data?.totalString
    }
}

private extension SearchResultView { @objc func filterButtonTapped(_ sender: FilterButton) {
        guard selectButtonIndex != sender.tag else { return }
        selectedButton.backgroundColor = Color.white
        selectedButton.setTitleColor(Color.black, for: .normal)
        sender.backgroundColor = Color.darkGray
        sender.setTitleColor(Color.white, for: .normal)
        selectedButton = sender
        selectButtonIndex = sender.tag
        
        collectionView.showSkeleton()
        delegate?.didfilterButtonTapped(index: sender.tag)
    }
}
