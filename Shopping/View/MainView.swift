//
//  MainView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit

class MainView: UIView {
    lazy var searchBar = {
        let bar = UISearchBar()
        bar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.addSubview(bar)
        return bar
    }()
    
    lazy var recentLabel = {
        let label = UILabel()
        label.font = Font.boldContent
        label.text = "최근 검색"
        self.addSubview(label)
        return label
    }()
    
    lazy var clearButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체 삭제", attributes: [.font: Font.content]), for: .normal)
        button.setTitleColor(Color.main, for: .normal)
        button.addTarget(self, action: #selector(self.clearButtonTapped), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalTo(recentLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    @objc func clearButtonTapped() {
        UserDefaultsManager.searchList = []
        tableView.reloadData()
    }
}
