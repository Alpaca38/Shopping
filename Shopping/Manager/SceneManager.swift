//
//  SceneManager.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

class SceneManager {
    private init() { }
    
    static let shared = SceneManager()
    
    func setScene(viewController: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
