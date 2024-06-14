//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    var searchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchText
    }
    

}
