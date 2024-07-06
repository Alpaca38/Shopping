//
//  LikeViewController.swift
//  Shopping
//
//  Created by 조규연 on 7/5/24.
//

import UIKit

final class LikeViewController: BaseViewController {
    private let likeView = LikeView()
    private let repository = SearchItemRepository()
    private var list: [SearchItemDTO] = [] {
        didSet {
            likeView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        likeView.searchBar.delegate = self
        likeView.collectionView.delegate = self
        likeView.collectionView.dataSource = self
        view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = repository.fetchAll()
        repository.printRealmURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = repository.fetchAll()
    }
}

extension LikeViewController: UISearchBarDelegate {
    
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = list[indexPath.item]
        cell.configure(data: data)
        return cell
    }
}
