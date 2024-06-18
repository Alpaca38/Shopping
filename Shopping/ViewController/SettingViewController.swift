//
//  SettingViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit
import SnapKit

class SettingViewController: BaseViewController {
    
    lazy var profileImageView = {
        let view = ProfileImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.smallProfile / 2, alpha: Image.Alpha.active)
        view.image = Image.Profile.allCases[UserDefaultsManager.user.image].profileImage
        self.view.addSubview(view)
        return view
    }()
    
    lazy var nicknameLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        return label
    }()
    
    lazy var dateLabel = {
        let label = UILabel()
        label.font = Font.small
        label.textColor = Color.gray
        label.text = UserDefaultsManager.user.registerDateString
        return label
    }()
    
    lazy var labelStackView = {
        let view = UIStackView(arrangedSubviews: [nicknameLabel, dateLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        self.view.addSubview(view)
        return view
    }()
    
    lazy var nextImage = {
        let view = UIImageView()
        view.tintColor = Color.darkGray
        view.image = Image.next
        self.view.addSubview(view)
        return view
    }()
    
    lazy var topViewButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(topViewButtonTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorInsetReference = .fromCellEdges
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.delegate = self
        view.dataSource = self
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LiteralString.setting
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameLabel.text = UserDefaultsManager.user.nickname
        profileImageView.image = Image.Profile.allCases[UserDefaultsManager.user.image].profileImage
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(Image.Size.smallProfile)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.height.equalTo(profileImageView).multipliedBy(0.5)
            $0.centerY.equalTo(profileImageView)
        }
        
        nextImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(profileImageView)
            $0.size.equalTo(20)
        }
        
        topViewButton.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(profileImageView).offset(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topViewButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

private extension SettingViewController {
    @objc func topViewButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        if indexPath.row == 4 {
            showSelectAlert()
        }
    }
    
}
