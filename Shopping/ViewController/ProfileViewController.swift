//
//  ProfileViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit
import SnapKit
import Toast

class ProfileViewController: BaseViewController {
    
    var nickname: String?
    
    lazy var profileImageView = {
        let view = ProfileImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.bigProfile / 2, alpha: Image.Alpha.active)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        self.view.addSubview(view)
        return view
    }()
    
    lazy var cameraImageView = {
        let view = UIImageView()
        view.backgroundColor = Color.main
        view.tintColor = Color.white
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Image.Size.camera / 2
        view.image = Image.camera
        self.view.addSubview(view)
        return view
    }()
    
    lazy var nicknameTextField = {
        let view = NicknameTextField()
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChage(_ :)), for: .editingChanged)
        self.view.addSubview(view)
        return view
    }()
    
    lazy var textFieldStateLabel = {
        let label = UILabel()
        label.font = Font.item
        label.textColor = Color.main
        self.view.addSubview(label)
        return label
    }()
    
    lazy var completeButton = {
        let button = CustomButton(title: "완료")
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsManager.standard.user.nickname == "" {
            title = LiteralString.profileSetting
            setRandomImage()
        } else {
            navigationItem.title = LiteralString.editProfile
            let saveButton = UIBarButtonItem(title: LiteralString.save, style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
        }
        
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageView.image = Image.Profile.allCases[UserDefaultsManager.standard.user.image].profileImage
        nicknameTextField.text = UserDefaultsManager.standard.user.nickname
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Image.Size.bigProfile)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
            $0.size.equalTo(Image.Size.camera)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(cameraImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        textFieldStateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        
        if UserDefaultsManager.standard.isLogin == false {
            completeButton.snp.makeConstraints {
                $0.top.equalTo(textFieldStateLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
    }
    
    func setRandomImage() {
        let random = Int.random(in: 0..<Image.Profile.allCases.count)
        UserDefaultsManager.standard.user.image = random
        profileImageView.image = Image.Profile.allCases[random].profileImage
    }
}

extension ProfileViewController {
    @objc func completeButtonTapped() {
        if textFieldStateLabel.text == TextFieldState.valid {
            UserDefaultsManager.standard.user.nickname = nickname!
            UserDefaultsManager.standard.isLogin = true
            SceneManager.shared.setScene(viewController: TabBarController())
        } else {
            self.view.makeToast("사용할 수 없는 닉네임입니다.", duration: 2.0, position: .center)
        }
    }
    
    @objc func profileImageTapped() {
        navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }
    
    @objc func saveButtonTapped() {
        UserDefaultsManager.standard.user.nickname = nicknameTextField.text!
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if text.contains(where: { LiteralString.specialCharacter.contains($0) }) {
            textFieldStateLabel.text = TextFieldState.specialCharacter
        } else if text.rangeOfCharacter(from: .decimalDigits) != nil {
            textFieldStateLabel.text = TextFieldState.number
        } else if text.count < 2 || text.count >= 10 {
            textFieldStateLabel.text = TextFieldState.count
        } else {
            textFieldStateLabel.text = TextFieldState.valid
            nickname = text
//            UserDefaultsManager.standard.user.nickname = text
//            UserDefaultsManager.standard.isLogin = true
        }
    }
}
