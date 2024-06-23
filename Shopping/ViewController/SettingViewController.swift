//
//  SettingViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class SettingViewController: BaseViewController {
    let settingView = SettingView()
    
    override func loadView() {
        super.loadView()
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        settingView.delegate = self
        view = settingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LiteralString.setting
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingView.nicknameLabel.text = UserDefaultsManager.user.nickname
        settingView.profileImageView.image = Image.Profile.allCases[UserDefaultsManager.user.image].profileImage
        settingView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

private extension SettingViewController {
    func showSelectAlert() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화 됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            SceneManager.shared.setNaviScene(viewController: OnBoardingViewController())
            self.resetUserDefaults()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func resetUserDefaults() {
        UserDefaultsManager.user = User(image: Image.Profile.allCases[.random(in: 0..<Image.Profile.allCases.count)].rawValue)
        UserDefaultsManager.isLogin = false
        UserDefaultsManager.likeList = []
        UserDefaultsManager.searchList = []
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        cell.configure(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == SettingOptions.allCases.firstIndex(of: SettingOptions.exit) {
            showSelectAlert()
        }
    }
    
}

extension SettingViewController: SettingViewDelegate {
    func didTopViewButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
