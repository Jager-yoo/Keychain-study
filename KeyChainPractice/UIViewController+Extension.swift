//
//  AlertManager.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showSegueAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        let segueAction = UIAlertAction(title: "비밀번호 변경하기", style: .destructive) { _ in
            self.performSegue(withIdentifier: "PasswordChangeViewController", sender: self)
        }
        alert.addAction(okAction)
        alert.addAction(segueAction)
        present(alert, animated: true, completion: nil)
    }
}
