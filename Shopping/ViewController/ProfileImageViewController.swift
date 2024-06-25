//
//  ProfileImageViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/14/24.
//

import UIKit

class ProfileImageViewController: BaseViewController {
    let profileImageView = ProfileImageView()
    
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
        
    }
   
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Image.Profile.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        cell.configure(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaultsManager.user.image = indexPath.item
        profileImageView.imageView.image = Image.Profile.allCases[indexPath.item].profileImage
        collectionView.reloadData()
    }
}
