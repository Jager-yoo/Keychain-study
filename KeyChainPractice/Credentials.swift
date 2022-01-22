//
//  Password.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/22.
//

import Foundation

struct Credentials {
    
    var password: String
}

enum KeychainError: Error {
    
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
