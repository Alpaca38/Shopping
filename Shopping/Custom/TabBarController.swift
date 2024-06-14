//
//  TabBarViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Color.main
        tabBar.unselectedItemTintColor = Color.gray
        
        let main = UINavigationController(rootViewController: MainViewController())
        main.tabBarItem = UITabBarItem(title: LiteralString.search, image: Image.search, tag: 0)
        
        setViewControllers([main], animated: true)
        
    }
    
}
