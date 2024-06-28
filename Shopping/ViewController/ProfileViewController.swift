//
//  ProfileViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

class ProfileViewController: BaseViewController {
    let profileView = ProfileView()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.nicknameTextField.text = UserDefaultsManager.user.nickname
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
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
}

extension ProfileViewController {
    @objc func saveButtonTapped() {
        profileView.saveButtonTapped()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        do {
            _ = try validateProfileName(text: text)
            profileView.textFieldStateLabel.text = TextFieldState.valid
            profileView.nickname = text
        } catch ValidationError.includeSpecial {
            profileView.textFieldStateLabel.text = TextFieldState.specialCharacter
        } catch ValidationError.includeInt {
            profileView.textFieldStateLabel.text = TextFieldState.number
        } catch ValidationError.isNotValidCount {
            profileView.textFieldStateLabel.text = TextFieldState.count
        } catch {
            
        }
    }
    
    func validateProfileName(text: String) throws -> Bool {
        guard !text.contains(where: { LiteralString.specialCharacter.contains($0) }) else {
            throw ValidationError.includeSpecial
        }
        guard text.rangeOfCharacter(from: .decimalDigits) == nil else {
            throw ValidationError.includeInt
        }
        guard text.count >= 2 && text.count < 10 else {
            throw ValidationError.isNotValidCount
        }
        return true
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
