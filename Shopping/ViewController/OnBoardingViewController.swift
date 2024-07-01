//
//  ViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

final class OnBoardingViewController: BaseViewController {
    private let onBoardingView = OnBoardingView()
    
    override func loadView() {
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
