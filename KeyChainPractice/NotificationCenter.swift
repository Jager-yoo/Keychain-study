//
//  NotificationCenter.swift
//  KeyChainPractice
//
//  Created by 유재호 on 2022/01/23.
//

import Foundation

let notificationCenter: NotificationCenter = NotificationCenter.default

extension Notification.Name {
    static let passwordDidDelete = Notification.Name("passwordDidDelete")
}
