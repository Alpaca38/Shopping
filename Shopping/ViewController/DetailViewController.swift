//
//  DetailViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class DetailViewController: BaseViewController {
    
    var titleText: String?
    var data: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
    }
    
    func setNavigationItem() {
        navigationItem.title = titleText
        
        var image: UIImage?
        if UserDefaultsManager.standard.likeList.contains(data!.productId) {
            image = Image.likeSelected
        } else {
            image = Image.likeUnSelected?.withRenderingMode(.alwaysOriginal)
        }
        let likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
}

private extension DetailViewController {
    @objc func likeButtonTapped() {
        if UserDefaultsManager.standard.likeList.contains(data!.productId) {
            UserDefaultsManager.standard.likeList.removeAll { $0 == data!.productId }
        } else {
            UserDefaultsManager.standard.likeList.append(data!.productId)
        }
        setNavigationItem()
    }
}
