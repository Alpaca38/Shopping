//
//  ProfileImageViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

final class ProfileImageViewController: BaseViewController {
    private let profileImageView = ProfileImageView()
    weak var delegate: ProfileImageViewDelegate?
    private let viewModel = ProfileImageViewModel()
    
    override func loadView() {
        profileImageView.collectionView.delegate = self
        profileImageView.collectionView.dataSource = self
        view = profileImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaultsManager.isLogin {
            title = LiteralString.editProfile
        } else {
            title = LiteralString.profileSetting
        }
        
        bindData()
    }
}

private extension ProfileImageViewController {
    func bindData() {
        viewModel.outputImage.bind { [weak self] _ in
            self?.profileImageView.collectionView.reloadData()
        }
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Image.Profile.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        let isSelected = viewModel.inputSelectedIndex.value == indexPath.item
        cell.configure(index: indexPath.item, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectedIndex.value = indexPath.item
        delegate?.didSelectCell(index: indexPath.item)
        guard let output = viewModel.outputImage.value else { return }
        profileImageView.imageView.image = UIImage(named: output)
    }
}
