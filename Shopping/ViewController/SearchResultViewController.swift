//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import Alamofire
import SnapKit

class SearchResultViewController: BaseViewController {
    
    var searchText: String?
    var page = 1
    var list = SearchResult(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            totalLabel.text = list.totalString
            collectionView.reloadData()
        }
    }
    
    lazy var totalLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        label.textColor = Color.main
        self.view.addSubview(label)
        return label
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.dataSource = self
        view.delegate = self
        view.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.view.addSubview(view)
        return view
    }()
    
    let simButton = {
        let button = FilterButton(title: Sort.sim.sortString)
        return button
    }()
    
    let dateButton = {
        let button = FilterButton(title: Sort.date.sortString)
        return button
    }()
    
    let dscButton = {
        let button = FilterButton(title: Sort.dsc.sortString)
        return button
    }()
    
    let ascButton = {
        let button = FilterButton(title: Sort.asc.sortString)
        return button
    }()
    
    lazy var filterStackView = {
        let view = UIStackView(arrangedSubviews: [simButton, dateButton, dscButton, ascButton])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .leading
        self.view.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchText
        
        callShoppingRequest(query: searchText!, sort: Sort.sim.rawValue)
        
        configureLayout()
    }
    
    func configureLayout() {
        totalLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(10)
            $0.leading.equalTo(totalLabel)
            $0.trailing.equalToSuperview().offset(-60)
            $0.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - sectionSpacing * 2 - cellSpacing
        layout.itemSize = CGSize(width: width/2, height: width/2 * 2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = list.items[indexPath.item]
        cell.configure(data: data)
        return cell
    }
    
    
}

extension SearchResultViewController {
    func callShoppingRequest(query: String, sort: Sort.RawValue) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        
        let parameters: Parameters = [
            "query": query,
            "start": page,
            "display": 30,
            "sort": sort
        ]
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        // success와 failure의 기준은 http status code를 기준으로
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: header)
        .validate()
        .responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let value):
                self.list = value
            case .failure(let error):
                print(error)
            }
        }
    }
}