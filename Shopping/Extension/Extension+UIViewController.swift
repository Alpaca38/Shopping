//
//  Extension+UIViewController.swift
//  Shopping
//
//  Created by 조규연 on 6/24/24.
//

import UIKit

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showAlert(title: String?, message: String?, buttonTitle: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
