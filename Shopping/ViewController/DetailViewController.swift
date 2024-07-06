//
//  DetailViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import WebKit
import SnapKit

final class DetailViewController: BaseViewController {
    private let repository = SearchItemRepository()
    var data: SearchItem?
    var dataDTO: SearchItemDTO?
    private var image: UIImage?
    private lazy var likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonTapped))
    private lazy var webView = {
        let view = WKWebView()
        if let data, let url = URL(string: data.link) {
            view.load(URLRequest(url: url))
        } else if let dataDTO, let url = URL(string: dataDTO.link){
            view.load(URLRequest(url: url))
        }
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        configureLayout()
    }
}

private extension DetailViewController {
    func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationItem() {
        if let data {
            navigationItem.title = data.title.asAttributedString().map { $0.string }
            updateLikeButton(for: data.productId)
        } else if let dataDTO {
            navigationItem.title = dataDTO.title.asAttributedString().map { $0.string }
            updateLikeButton(for: dataDTO.productId)
        }
    }
    
    func updateLikeButton(for productId: String) {
        if UserDefaultsManager.likeList.contains(productId) {
            image = Image.likeSelected
        } else {
            image = Image.likeUnSelected?.withRenderingMode(.alwaysOriginal)
        }
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonTapped() {
        if let data {
            if UserDefaultsManager.likeList.contains(data.productId) {
                UserDefaultsManager.likeList.remove(data.productId)
                if let object = repository.fetchItemFromProduct(productID: data.productId) {
                    repository.deleteItem(data: object)
                }
                likeButton.image = Image.likeUnSelected?.withRenderingMode(.alwaysOriginal)
            } else {
                UserDefaultsManager.likeList.insert(data.productId)
                repository.createItem(data: SearchItemDTO(from: data))
                likeButton.image = Image.likeSelected
            }
        } else if let dataDTO {
            if UserDefaultsManager.likeList.contains(dataDTO.productId) {
                UserDefaultsManager.likeList.remove(dataDTO.productId)
                repository.deleteItem(data: dataDTO)
                likeButton.image = Image.likeUnSelected?.withRenderingMode(.alwaysOriginal)
            } else {
                UserDefaultsManager.likeList.insert(dataDTO.productId)
                repository.createItem(data: dataDTO)
                likeButton.image = Image.likeSelected
            }
        }
    }
}
