//
//  PasswordChangeViewController.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet private weak var currentPassword: UITextField!
    @IBOutlet private weak var newPassword: UITextField!
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPassword.placeholder = retrieveCurrentPassword()
        
        // 새로운 비밀번호를 입력하지 않으면 버튼이 비활성화 상태(disabled state)로 대기하도록
        changePasswordButton.isEnabled = false
    }
    
    private func retrieveCurrentPassword() -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            return "아직 비밀번호를 등록하지 않았습니다."
        }
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else {
            return "비밀번호를 가져오지 못했습니다."
        }
        
        return password
    }
}
