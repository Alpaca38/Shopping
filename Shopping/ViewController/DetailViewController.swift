//
//  DetailViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import WebKit
import SnapKit

class DetailViewController: BaseViewController {
    
    var titleText: String?
    var data: Item?
    
    lazy var webView = {
        let view = WKWebView()
        let url = URL(string: data!.link)!
        view.load(URLRequest(url: url))
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        configureLayout()
    }
    
    func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationItem() {
        navigationItem.title = data?.title.asAttributedString().map { $0.string }
        
        var image: UIImage?
        if UserDefaultsManager.likeList.contains(data!.productId) {
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
        guard let data else { return }
        if UserDefaultsManager.likeList.contains(data.productId) {
            UserDefaultsManager.likeList.remove(data.productId)
        } else {
            UserDefaultsManager.likeList.insert(data.productId)
        }
        setNavigationItem()
    }
}
