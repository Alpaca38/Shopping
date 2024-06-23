//
//  MainViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class MainViewController: BaseViewController {
    let emptyMainView = EmptyMainView()
    let mainView = MainView()
    
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
        if UserDefaultsManager.searchList.isEmpty {
            if view != emptyMainView {
                emptyMainView.searchBar.delegate = self
                view = emptyMainView
            }
        } else {
            if view != mainView {
                mainView.searchBar.delegate = self
                mainView.tableView.delegate = self
                mainView.tableView.dataSource = self
                view = mainView
            }
            mainView.tableView.reloadData()
        }
        view.backgroundColor = .systemBackground
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if UserDefaultsManager.searchList.contains(searchBar.text!) == false {
            UserDefaultsManager.searchList.insert(searchBar.text!, at: 0)
        }
        let vc = SearchResultViewController()
        vc.searchText = searchBar.text!
        searchBar.text = nil
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaultsManager.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.configure(index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.searchText = UserDefaultsManager.searchList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: SearchTableViewCellDelegate {
    func didXMarkTapped(cell: UITableViewCell) {
        if let indexPath = mainView.tableView.indexPath(for: cell) {
            UserDefaultsManager.searchList.remove(at: indexPath.row)
            mainView.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
