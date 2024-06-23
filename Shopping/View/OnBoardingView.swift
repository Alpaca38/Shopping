//
//  OnBoardingView.swift
//  Shopping
//
//  Created by 조규연 on 6/23/24.
//

import UIKit
import SnapKit
import Toast

class OnBoardingView: UIView {
    
    weak var delegate: OnBoardingViewDelegate?
    
    lazy var titleLabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.font = Font.futuraBold
        label.textColor = Color.main
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    
    lazy var imageView = {
        let view = UIImageView()
        view.image = Image.launch
        view.contentMode = .scaleAspectFill
        self.addSubview(view)
        return view
    }()
    
    lazy var startButton = {
        let button = CustomButton(title: "시작하기")
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(63)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OnBoardingView {
    @objc func startButtonTapped() {
        delegate?.didStartButtonTapped()
    }
}
