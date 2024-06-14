//
//  MainViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    lazy var searchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.view.addSubview(bar)
        return bar
    }()
    
    lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Image.empty
        self.view.addSubview(view)
        return view
    }()
    
    lazy var emptyLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        label.textAlignment = .center
        label.text = "최근 검색어가 없어요"
        self.view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = UserDefaultsManager.standard.user.mainNaviTitle
        configureLayout()
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        if UserDefaultsManager.standard.searchList.isEmpty {
            imageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(view.snp.width).multipliedBy(0.7)
            }
            
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
        } else {
            
        }
    }

}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaultsManager.standard.searchList.append(searchBar.text!)
        searchBar.text = nil
        // 검색 결과 화면으로 이동
    }
}
