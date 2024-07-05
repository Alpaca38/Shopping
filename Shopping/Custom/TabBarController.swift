//
//  TabBarViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Color.main
        tabBar.unselectedItemTintColor = Color.gray
        
        let main = UINavigationController(rootViewController: SearchViewController())
        main.tabBarItem = UITabBarItem(title: LiteralString.search, image: Image.search, tag: 0)
        
        let like = UINavigationController(rootViewController: LikeViewController())
        like.tabBarItem = UITabBarItem(title: LiteralString.like, image: Image.like, tag: 1)
        
        let setting = UINavigationController(rootViewController: SettingViewController())
        setting.tabBarItem = UITabBarItem(title: LiteralString.settingItem, image: Image.setting, tag: 2)
        
        setViewControllers([main, like, setting], animated: true)
        
    }
    
}
