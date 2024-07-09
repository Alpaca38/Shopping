//
//  ProfileViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private let profileView = ProfileView()
    private let viewModel = ProfileViewModel()
    private var selectedIndex: Int?
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.delegate = self
        profileView.nicknameTextField.delegate = self
        profileView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChage(_ :)), for: .editingChanged)
        
        setNavi()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.nicknameTextField.text = UserDefaultsManager.user.nickname
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension ProfileViewController {
    func setNavi() {
        if UserDefaultsManager.user.nickname == "" {
            title = LiteralString.profileSetting
            setRandomImage()
        } else {
            navigationItem.title = LiteralString.editProfile
            let saveButton = UIBarButtonItem(title: LiteralString.save, style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
            profileView.profileImageView.image = Image.Profile.allCases[UserDefaultsManager.user.image].profileImage
        }
    }
    
    func setRandomImage() {
        let random = Int.random(in: 0..<Image.Profile.allCases.count)
        UserDefaultsManager.user.image = random
        profileView.profileImageView.image = Image.Profile.allCases[random].profileImage
    }
    
    @objc func saveButtonTapped() {
        profileView.saveButtonTapped()
    }
    
    func bindData() {
        viewModel.outputValidText.bind { [weak self] in
            guard let self else { return }
            profileView.textFieldStateLabel.text = $0
        }
        
        viewModel.outputNickname.bind { [weak self] in
            guard let self else { return }
            profileView.nickname = $0
        }
        
        viewModel.outputValid.bind { [weak self] in
            guard let self else { return }
            profileView.completeButton.backgroundColor = $0 ? Color.main : .gray
            profileView.completeButton.isEnabled = $0
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        viewModel.inputText.value = textField.text
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func didProfileImageTapped() {
        let vc = ProfileImageViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSave() {
        if let index = selectedIndex {
            UserDefaultsManager.user.image = index
        }
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: ProfileImageViewDelegate {
    func didSelectCell(index: Int) {
        profileView.profileImageView.image = Image.Profile.allCases[index].profileImage
        selectedIndex = index
    }
}
