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
    
    private var selectedButton: UIButton?
    private var selectButtonIndex: Int = 0
    
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
        view.prefetchDataSource = self
        view.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        self.view.addSubview(view)
        return view
    }()
    
    lazy var simButton = {
        let button = FilterButton(title: Sort.sim.sortString)
        button.tag = 0
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dateButton = {
        let button = FilterButton(title: Sort.date.sortString)
        button.tag = 1
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dscButton = {
        let button = FilterButton(title: Sort.dsc.sortString)
        button.tag = 2
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var ascButton = {
        let button = FilterButton(title: Sort.asc.sortString)
        button.tag = 3
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
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
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - sectionSpacing * 2 - cellSpacing
        layout.itemSize = CGSize(width: width/2, height: width/2 * 2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}

private extension SearchResultViewController {
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        selectedButton?.backgroundColor = Color.white
        selectedButton?.setTitleColor(Color.black, for: .normal)
        sender.backgroundColor = Color.darkGray
        sender.setTitleColor(Color.white, for: .normal)
        selectedButton = sender
        
        page = 1
        
        selectButtonIndex = sender.tag
        callShoppingRequest(query: searchText!, sort: Sort.allCases[sender.tag].rawValue)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = list.items[indexPath.item]
        cell.delegate = self
        cell.configure(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = list.items[indexPath.item]
        let vc = DetailViewController()
        vc.titleText = searchText
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if list.items.count - 4 == $0.item {
                page += 1
                callShoppingRequest(query: searchText!, sort: Sort.allCases[selectButtonIndex].rawValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func didLikeButtonTapped(cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let productId = list.items[indexPath.item].productId
            if UserDefaultsManager.standard.likeList.contains(productId) {
                UserDefaultsManager.standard.likeList.removeAll { $0 == productId }
            } else {
                UserDefaultsManager.standard.likeList.append(list.items[indexPath.item].productId)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

private extension SearchResultViewController {
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
                if self.page == 1 {
                    self.list = value
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                } else {
                    self.list.items.append(contentsOf: value.items)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
