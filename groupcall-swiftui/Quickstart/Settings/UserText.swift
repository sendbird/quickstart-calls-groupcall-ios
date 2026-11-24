//
//  UserText.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation

/// How the signed-in user appears on the main and settings screens.
enum UserText {
    static func nickname(_ nickname: String?) -> String {
        nickname?.collapsed ?? "—"
    }

    static func userId(_ userId: String?) -> String {
        "User ID: \(userId ?? "")"
    }
}
