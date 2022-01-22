//
//  PasswordChangeViewController.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

class PasswordChangeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var changePasswordButton: UIButton!
    
    @IBAction private func changePassword(_ sender: UIButton) {
        
        guard newPasswordTextField.text! != currentPasswordTextField.placeholder ?? "" else {
            showBasicAlert(title: "기존 비밀번호와 중복입니다.", message: "새로운 비밀번호를 등록해주세요!", handler: nil)
            return
        }
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        
        // 만약 변경할 비밀번호가 공백("") 이면, 비밀번호 삭제시키는 로직
        guard newPasswordTextField.text!.isEmpty == false else {
            let _ = SecItemDelete(query as CFDictionary)
            showBasicAlert(title: "비밀번호가 삭제됐습니다.", message: "새로운 비밀번호를 다시 등록해주세요!") { _ in
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
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
        newPasswordTextField.delegate = self
        currentPasswordTextField.placeholder = retrieveCurrentPassword()
        
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
    
    // 아래 메서드는 textField 값이 변경되기 직전마다 불린다.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // ⭐️ textField 가 비어있다면, 버튼을 비활성화시키고 리턴해라!
        guard newPasswordTextField.text!.isEmpty == false else {
            changePasswordButton.isEnabled = false
            return
        }
        
        // textField 가 수정을 시작했고 비어있지 않다면, 버튼을 활성화(enable) 시켜라!
        changePasswordButton.isEnabled = true
    }
}
