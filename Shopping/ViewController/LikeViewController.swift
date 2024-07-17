//
//  LikeViewController.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import UIKit

final class LikeViewController: BaseViewController {
    private let likeView = LikeView()
    private let viewModel = LikeViewModel()
    
    override func loadView() {
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.repository.printRealmURL()
        bindData()
    }
}

private extension LikeViewController {
    func bindData() {
        viewModel.outputList.bind { [weak self] _ in
            self?.likeView.collectionView.reloadData()
        }
    }
}

extension LikeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchText.value = searchText
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = viewModel.outputList.value[indexPath.item]
        cell.configure(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.outputList.value[indexPath.row]
        let vc = DetailViewController()
        vc.dataDTO = data
        navigationController?.pushViewController(vc, animated: true)
    }
}
