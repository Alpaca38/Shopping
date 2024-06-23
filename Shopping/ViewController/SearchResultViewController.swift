//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import Alamofire
import SnapKit
import SkeletonView
import Toast

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
        view.isSkeletonable = true
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
        
        collectionView.showSkeleton()
        do {
            let _ = try validateQuery(query: searchText!)
            getShoppingData(sort: Sort.sim.rawValue)
        } catch ShoppingQueryError.whitespace {
            self.view.makeToast("공백은 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
        } catch ShoppingQueryError.specialCharacter {
            self.view.makeToast("특수문자는 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
        } catch {
            
        }
        
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
        
        collectionView.showSkeleton()
        getShoppingData(sort: Sort.allCases[sender.tag].rawValue)
    }
    
    func validateQuery(query: String) throws -> Bool {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            throw ShoppingQueryError.whitespace
        }
        guard !query.contains(where: { LiteralString.allSpecialCharacter.contains($0) }) else {
            throw ShoppingQueryError.specialCharacter
        }
        return true
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
                getShoppingData(sort: Sort.allCases[selectButtonIndex].rawValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension SearchResultViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return SearchResultCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func didLikeButtonTapped(cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let productId = list.items[indexPath.item].productId
            if UserDefaultsManager.likeList.contains(productId) {
                UserDefaultsManager.likeList.removeAll { $0 == productId }
            } else {
                UserDefaultsManager.likeList.append(list.items[indexPath.item].productId)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

private extension SearchResultViewController {
    func getShoppingData(sort: Sort.RawValue) {
        NetworkManager.shared.getShoppingData(query: searchText!, sort: sort, page: page) { result in
            switch result {
            case .success(let success):
                if self.page == 1 {
                    self.list = success
                    if !self.list.items.isEmpty {
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.hideSkeleton()
                    }
                } else {
                    self.list.items.append(contentsOf: success.items)
                }
            case .failure(let failure):
                self.view.makeToast("\(failure.localizedDescription)", duration: 2.0, position: .center)
            }
        }
    }
}
