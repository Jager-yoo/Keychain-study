//
//  AlertManager.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
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
    
    // 비밀번호를 조회하고, 있으면 String 으로 리턴하고, 없으면 nil 리턴하는 메서드
    func retrieveCurrentPassword() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            return nil
        }
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else {
            showBasicAlert(title: "비밀번호 가져오는 도중 에러 발생", message: "다시 시도해주세요.") { _ in
                self.dismiss(animated: true, completion: nil)
            }
            return nil
        }
        
        return password
    }
}
