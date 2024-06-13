//
//  ViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit
import SnapKit

class OnBoardingViewController: BaseViewController {
    
    lazy var titleLabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.font = Font.futuraBold
        label.textColor = Color.main
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    
    lazy var imageView = {
        let view = UIImageView()
        view.image = Image.launch
        view.contentMode = .scaleAspectFill
        self.view.addSubview(view)
        return view
    }()
    
    lazy var startButton = {
        let button = CustomButton(title: "시작하기")
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
}

extension OnBoardingViewController {
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(view.snp.width).multipliedBy(0.75)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension OnBoardingViewController {
    @objc func startButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
