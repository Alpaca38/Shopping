//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SkeletonView
import Toast

final class SearchResultViewController: BaseViewController {
    private let repository = SearchItemRepository()
    private let searchResultView = SearchResultView()
    private let viewModel = SearchResultViewModel()
    
    var searchText: String?
    
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
        setViewModel()
        
        viewModel.inputPage.value = 1
        viewModel.inputSearchText.value = searchText
        
        bindData()
        
        searchResultView.collectionView.showSkeleton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultView.collectionView.reloadData()
    }
}

private extension SearchResultViewController {
    func bindData() {
        viewModel.outputList.bind { [weak self] _ in
            self?.searchResultView.collectionView.reloadData()
        }
        
        viewModel.outputNetworkSuccess.bind(false) { [weak self] _ in
            guard let self else { return }
            searchResultView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            searchResultView.collectionView.hideSkeleton()
        }
        
        viewModel.outputNetworkError.bind { [weak self] error in
            guard let error else { return }
            self?.view.makeToast("\(error.rawValue)", duration: 2.0, position: .center)
        }
    }
    
    func setViewModel() {
        viewModel.sendValidationError = { [weak self] error in
            guard let self else { return }
            switch error {
            case .whitespace:
                DispatchQueue.main.async {
                    self.view.makeToast("공백은 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
                }
            case .specialCharacter:
                DispatchQueue.main.async {
                    self.view.makeToast("특수문자는 검색되지 않습니다. 다시 입력해주세요.", duration: 2.0, position: .center)
                }
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = viewModel.outputList.value else { return 0 }
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = viewModel.outputList.value?.items[indexPath.item]
        cell.delegate = self
        cell.configure(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.outputList.value?.items[indexPath.item]
        let vc = DetailViewController()
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let list = viewModel.outputList.value else { return }
        indexPaths.forEach {
            if list.items.count - 4 == $0.item {
                viewModel.inputButtonIndex.value = searchResultView.selectButtonIndex
                viewModel.inputPage.value += 1
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
        guard let list = viewModel.outputList.value else { return  0}
        return list.items.count
    }
    
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func didLikeButtonTapped(cell: UICollectionViewCell) {
        if let indexPath = searchResultView.collectionView.indexPath(for: cell) {
            guard let list = viewModel.outputList.value else { return }
            let searchItem = list.items[indexPath.item]
            let dto = SearchItemDTO(from: searchItem)
            if UserDefaultsManager.likeList.contains(searchItem.productId) {
                UserDefaultsManager.likeList.remove(searchItem.productId)
                if let data = repository.fetchItemFromProduct(productID: searchItem.productId) {
                    repository.deleteItem(data: data)
                }
            } else {
                UserDefaultsManager.likeList.insert(searchItem.productId)
                repository.createItem(data: dto)
            }
            searchResultView.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension SearchResultViewController: SearchResultViewDelegate {
    func didfilterButtonTapped(index: Int) {
        viewModel.inputButtonIndex.value = index
        viewModel.inputPage.value = 1
    }
}
