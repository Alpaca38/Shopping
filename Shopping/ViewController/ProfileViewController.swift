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
    
    lazy var stateLabel = {
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
        
        title = "PROFILE SETTING"
        
        configureLayout()
        setRandomImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageView.image = Image.Profile.allCases[UserDefaultsManager.standard.user.image].profileImage
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
        
        stateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(stateLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setRandomImage() {
        let random = Int.random(in: 0..<Image.Profile.allCases.count)
        profileImageView.image = Image.Profile.allCases[random].profileImage
    }
}

extension ProfileViewController {
    @objc func completeButtonTapped() {
        if UserDefaultsManager.standard.isLogin {
            SceneManager.shared.setScene(viewController: MainViewController())
        } else {
            self.view.makeToast("사용할 수 없는 닉네임입니다.", duration: 2.0, position: .center)
        }
    }
    
    @objc func profileImageTapped() {
        navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if text.contains(where: { LiteralString.specialCharacter.contains($0) }) {
            stateLabel.text = "닉네임에 @,#,$,% 는 포함할 수 없어요."
        } else if text.rangeOfCharacter(from: .decimalDigits) != nil {
            stateLabel.text = "닉네임에 숫자는 포함할 수 없어요."
        } else if text.count < 2 || text.count >= 10 {
            stateLabel.text = "2글자 이상 10글자 미만으로 설정해주세요."
        } else {
            stateLabel.text = "사용할 수 있는 닉네임이에요."
            UserDefaultsManager.standard.user.nickname = text
            UserDefaultsManager.standard.isLogin = true
        }
    }
}
