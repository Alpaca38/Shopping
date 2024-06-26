//
//  MainViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class SearchViewController: BaseViewController {
    let emptyMainView = EmptyMainView()
    let searchView = SearchView()
    
    var list: [String] {
        get {
            return UserDefaultsManager.searchList
        }
        set {
            UserDefaultsManager.searchList = newValue
            searchView.tableView.reloadData()
        }
    }
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = UserDefaultsManager.user.mainNaviTitle
        setupView()
    }
    
    func setupView() {
        if list.isEmpty {
            if view != emptyMainView {
                emptyMainView.searchBar.delegate = self
                view = emptyMainView
            }
        } else {
            if view != searchView {
                searchView.searchBar.delegate = self
                searchView.tableView.delegate = self
                searchView.tableView.dataSource = self
                view = searchView
            }
        }
        view.backgroundColor = .systemBackground
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if list.contains(searchBar.text!) == false {
            list.insert(searchBar.text!, at: 0)
        }
        let vc = SearchResultViewController()
        vc.searchText = searchBar.text!
        searchBar.text = nil
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.configure(index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.searchText = list[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    func didXMarkTapped() {
        searchView.tableView.reloadData()
    }
}
