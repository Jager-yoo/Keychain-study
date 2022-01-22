//
//  PasswordChangeViewController.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    @IBAction private func changePassword(_ sender: UIButton) {
        
        guard newPasswordTextField.text! != currentPasswordTextField.placeholder! else {
            showBasicAlert(title: "기존 비밀번호와 중복입니다.", message: "새로운 비밀번호를 등록해주세요!", handler: nil)
            return
        }
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let newCredentials = Credentials(password: newPasswordTextField.text!)
        let newPassword = newCredentials.password.data(using: .utf8)!
        // kSecClass as String: kSecClassGenericPassword -> 이건 필요 없음
        let attributes: [String: Any] = [kSecValueData as String: newPassword]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            showBasicAlert(title: "아직 비밀번호를 등록하지 않았습니다.", message: "새로운 비밀번호를 먼저 등록해주세요!") { _ in
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        guard status == errSecSuccess else {
            showBasicAlert(title: "에러 발생", message: "무슨 에러인지는 나도 몰루") { _ in
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        showBasicAlert(title: "비밀번호를 성공적으로 변경했습니다!", message: "아싸") { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordTextField.placeholder = retrieveCurrentPassword()
        
        // 새로운 비밀번호를 입력하지 않으면 버튼이 비활성화 상태(disabled state)로 대기하도록
//        changePasswordButton.isEnabled = false
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
