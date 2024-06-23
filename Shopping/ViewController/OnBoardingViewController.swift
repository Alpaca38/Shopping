//
//  ViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit
import SnapKit

class OnBoardingViewController: BaseViewController {
    let onBoardingView = OnBoardingView()
    
    override func loadView() {
        super.loadView()
        view = onBoardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingView.delegate = self
    }
    
}

extension OnBoardingViewController: OnBoardingViewDelegate {
    func didStartButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
