//
//  MainViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    private let emptyMainView = EmptyMainView()
    private let searchView = SearchView()
    private let viewModel = SearchViewModel()
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = UserDefaultsManager.user.mainNaviTitle
    }
    
    private func setupView() {
        if viewModel.outputList.value.isEmpty {
            if view != emptyMainView {
                emptyMainView.searchBar.delegate = self
                view = emptyMainView
            }
        } else {
            if view != searchView {
                searchView.searchBar.delegate = self
                searchView.tableView.delegate = self
                searchView.tableView.dataSource = self
                searchView.didClearButtonTapped = {
                    UserDefaultsManager.searchList = []
                    self.viewModel.outputList.value = UserDefaultsManager.searchList
                }
                view = searchView
            }
        }
        view.backgroundColor = .systemBackground
    }
}

private extension SearchViewController {
    func bindData() {
        viewModel.outputList.bind { [weak self] list in
            guard let self else { return }
            UserDefaultsManager.searchList = list
            setupView()
            searchView.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if !viewModel.outputList.value.contains(text) && !text.isEmpty && !text.contains(LiteralString.allSpecialCharacter) {
            viewModel.outputList.value.insert(searchBar.text!, at: 0)
        }
        let vc = SearchResultViewController()
        vc.viewModel.inputSearchText.value = searchBar.text!
        searchBar.text = nil
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.configure(index: indexPath.row)
        cell.didXmarkTapped = { [weak self] in
            guard let self else { return }
            viewModel.outputList.value = UserDefaultsManager.searchList
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.viewModel.inputSearchText.value = viewModel.outputList.value[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
