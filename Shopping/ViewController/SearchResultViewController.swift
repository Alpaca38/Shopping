//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SkeletonView
import Toast

class SearchResultViewController: BaseViewController {
    let searchResultView = SearchResultView()
    
    var searchText: String?
    var page = 1
    var list = SearchResult(lastBuildDate: "", total: 0, start: 0, display: 0, items: []) {
        didSet {
            searchResultView.totalLabel.text = list.totalString
            searchResultView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        searchResultView.collectionView.dataSource = self
        searchResultView.collectionView.delegate = self
        searchResultView.collectionView.prefetchDataSource = self
        searchResultView.delegate = self
        view = searchResultView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchText
        
        searchResultView.collectionView.showSkeleton()
        do {
            let _ = try validateQuery(query: searchText!)
            getShoppingData(sort: Sort.sim.rawValue)
        } catch ShoppingQueryError.whitespace {
            DispatchQueue.main.async {
                self.view.makeToast("공백은 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
            }
        } catch ShoppingQueryError.specialCharacter {
            DispatchQueue.main.async {
                self.view.makeToast("특수문자는 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
            }
        } catch {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultView.collectionView.reloadData()
    }
}

private extension SearchResultViewController {
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
                getShoppingData(sort: Sort.allCases[searchResultView.selectButtonIndex].rawValue)
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
        if let indexPath = searchResultView.collectionView.indexPath(for: cell) {
            let productId = list.items[indexPath.item].productId
            if UserDefaultsManager.likeList.contains(productId) {
                UserDefaultsManager.likeList.removeAll { $0 == productId }
            } else {
                UserDefaultsManager.likeList.append(list.items[indexPath.item].productId)
            }
            searchResultView.collectionView.reloadItems(at: [indexPath])
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
                        self.searchResultView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.searchResultView.collectionView.hideSkeleton()
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

extension SearchResultViewController: SearchResultViewDelegate {
    func didfilterButtonTapped(index: Int) {
        page = 1
        getShoppingData(sort: Sort.allCases[index].rawValue)
    }
}
