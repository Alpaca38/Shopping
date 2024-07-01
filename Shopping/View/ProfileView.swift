//
//  ProfileView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit
import Toast

final class ProfileView: BaseView {
    
    weak var delegate: ProfileViewDelegate?
    
    var nickname: String?
    
    lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.bigProfile / 2, alpha: Image.Alpha.active)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        self.addSubview(view)
        return view
    }()
    
    private lazy var cameraImageView = {
        let view = UIImageView()
        view.backgroundColor = Color.main
        view.tintColor = Color.white
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Image.Size.camera / 2
        view.image = Image.camera
        self.addSubview(view)
        return view
    }()
    
    lazy var nicknameTextField = {
        let view = NicknameTextField()
        self.addSubview(view)
        return view
    }()
    
    lazy var textFieldStateLabel = {
        let label = UILabel()
        label.font = Font.item
        label.textColor = Color.main
        self.addSubview(label)
        return label
    }()
    
    private lazy var completeButton = {
        let button = CustomButton(title: "완료")
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        self.addSubview(button)
        return button
    }()
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
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
        
        if UserDefaultsManager.isLogin == false {
            completeButton.snp.makeConstraints {
                $0.top.equalTo(textFieldStateLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
    }
}


private extension ProfileView {
    @objc func completeButtonTapped() {
        if textFieldStateLabel.text == TextFieldState.valid {
            guard let nickname = nickname else { return }
            UserDefaultsManager.user.nickname = nickname
            UserDefaultsManager.isLogin = true
            SceneManager.shared.setScene(viewController: TabBarController())
        } else {
            self.makeToast("사용할 수 없는 닉네임입니다.", duration: 2.0, position: .center)
        }
    }
    
    @objc func profileImageTapped() {
        delegate?.didProfileImageTapped()
    }
}

extension ProfileView {
    func saveButtonTapped() {
        if textFieldStateLabel.text == TextFieldState.valid || nicknameTextField.text == UserDefaultsManager.user.nickname {
            UserDefaultsManager.user.nickname = nicknameTextField.text!
            delegate?.didSave()
        } else {
            self.makeToast("사용할 수 없는 닉네임입니다.", duration: 2.0, position: .center)
        }
    }
}
