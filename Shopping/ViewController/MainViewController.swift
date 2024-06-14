//
//  MainViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    lazy var searchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.view.addSubview(bar)
        return bar
    }()
    
    lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Image.empty
        self.view.addSubview(view)
        return view
    }()
    
    lazy var emptyLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        label.textAlignment = .center
        label.text = "최근 검색어가 없어요"
        self.view.addSubview(label)
        return label
    }()
    
    lazy var recentLabel = {
        let label = UILabel()
        label.font = Font.boldContent
        label.text = "최근 검색"
        self.view.addSubview(label)
        return label
    }()
    
    lazy var clearButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체 삭제", attributes: [.font: Font.content]), for: .normal)
        button.setTitleColor(Color.main, for: .normal)
        button.addTarget(self, action: #selector(self.clearButtonTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = UserDefaultsManager.standard.user.mainNaviTitle
        configureLayout()
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        if UserDefaultsManager.standard.searchList.isEmpty {
            imageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(view.snp.width).multipliedBy(0.7)
            }
            
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
        } else {
            recentLabel.snp.makeConstraints {
                $0.top.equalTo(searchBar.snp.bottom).offset(20)
                $0.leading.equalToSuperview().offset(20)
            }
            
            clearButton.snp.makeConstraints {
                $0.centerY.equalTo(recentLabel)
                $0.trailing.equalToSuperview().offset(-20)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(recentLabel.snp.bottom).offset(8)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
}

extension MainViewController {
    @objc func clearButtonTapped() {
        UserDefaultsManager.standard.searchList = []
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaultsManager.standard.searchList.insert(searchBar.text!, at: 0)
        let vc = SearchResultViewController()
        vc.searchText = searchBar.text!
        searchBar.text = nil
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaultsManager.standard.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.configure(index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.searchText = UserDefaultsManager.standard.searchList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: SearchTableViewCellDelegate {
    func didXMarkTapped(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            UserDefaultsManager.standard.searchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
