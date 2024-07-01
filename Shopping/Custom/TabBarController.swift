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
        
        let setting = UINavigationController(rootViewController: SettingViewController())
        setting.tabBarItem = UITabBarItem(title: LiteralString.settingItem, image: Image.setting, tag: 1)
        
        setViewControllers([main, setting], animated: true)
        
    }
    
}
