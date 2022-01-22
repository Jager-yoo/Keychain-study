//
//  ViewController.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction func showDiaryButtonTapped(_ sender: UIButton) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true, // 이거 필요
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef? // 검색 결과가 담기는 변수
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            showAlert(title: "아직 비밀번호를 등록하지 않았습니다.", message: "새로운 비밀번호를 등록해주세요!")
            return
        }
        
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else {
            showAlert(title: "에러 발생", message: "무슨 에러인지는 나도 몰루")
            return
        }
        
        guard password == passwordTextField.text! else {
            showAlert(title: "비밀번호가 일치하지 않습니다.", message: "잘 떠올려보세요!")
            return
        }
        
        // 비밀번호 일치한다면 다이어리 뷰컨으로 보내주기 -> DiaryViewController
        guard let diaryVC = self.storyboard?.instantiateViewController(withIdentifier: "DiaryViewController") as? DiaryViewController else { return }
        diaryVC.modalPresentationStyle = .fullScreen
        self.present(diaryVC, animated: true, completion: nil)
    }
    
    @IBAction private func passwordRegisterButtonTapped(_ sender: UIButton) {
        let credentials = Credentials(password: passwordTextField.text!)
        let password = credentials.password.data(using: .utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecValueData as String: password]
        
        // status 라는 자체가, 아이템 애드 한 이후에, 무슨 결과가 나왔는지를 받는 것임.
        let status = SecItemAdd(query as CFDictionary, nil)
        // status 상수 만든 것에서 끝난 것임.
        // 그 이후 처리는 Alert 보여주는 식으로 하면 됨.
        print("💚 status : \(status)")
        
        switch status {
        case errSecSuccess:
            showAlert(title: "새로운 비밀번호가 등록됐습니다.", message: "아싸")
        case -25299:
            showAlert(title: "비밀번호가 이미 등록되어 있습니다.", message: "잘 떠올려보세요!")
        default:
            showAlert(title: "에러 발생", message: "무슨 에러인지는 나도 몰루")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

