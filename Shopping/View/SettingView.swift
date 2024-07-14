//
//  SettingView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    weak var delegate: SettingViewDelegate?
    
    private lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.smallProfile / 2, alpha: Image.Alpha.active)
        view.image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage)
        self.addSubview(view)
        return view
    }()
    
    private lazy var nicknameLabel = {
        let label = UILabel()
        label.font = Font.boldTitle
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.font = Font.small
        label.textColor = Color.gray
        label.text = UserDefaultsManager.user.registerDateString
        return label
    }()
    
    private lazy var labelStackView = {
        let view = UIStackView(arrangedSubviews: [nicknameLabel, dateLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        self.addSubview(view)
        return view
    }()
    
    private lazy var nextImage = {
        let view = UIImageView()
        view.tintColor = Color.darkGray
        view.image = Image.next
        self.addSubview(view)
        return view
    }()
    
    private lazy var topViewButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(topViewButtonTapped), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorInsetReference = .fromCellEdges
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        self.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
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
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(profileImageView).offset(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topViewButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension SettingView {
    func configureView() {
        nicknameLabel.text = UserDefaultsManager.user.nickname
        profileImageView.image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage)
    }
}

private extension SettingView {
    @objc func topViewButtonTapped() {
        delegate?.didTopViewButtonTapped()
    }
}
