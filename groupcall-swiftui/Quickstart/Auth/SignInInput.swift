//
//  SignInInput.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation

/// The values that a user signs in with.
struct SignInCredential: Equatable {
    let appId: String
    let userId: String
    /// `nil` when the Sendbird application doesn't require an access token.
    let accessToken: String?
}

/// What the user typed on the sign-in screen.
struct SignInInput {
    var appId = ""
    var userId = ""
    var accessToken = ""

    enum ValidationError: LocalizedError, Equatable {
        case invalidAppId
        case invalidUserId

        var errorDescription: String? {
            switch self {
            case .invalidAppId: "Please enter valid app ID"
            case .invalidUserId: "Please enter valid user ID"
            }
        }
    }

    /// Trims the values and checks that the application ID and the user ID aren't empty.
    func validated() throws -> SignInCredential {
        guard let appId = appId.collapsed else { throw ValidationError.invalidAppId }
        guard let userId = userId.collapsed else { throw ValidationError.invalidUserId }
        return SignInCredential(appId: appId, userId: userId, accessToken: accessToken.collapsed)
    }
}

extension String {
    /// The string without leading and trailing whitespace, or `nil` when nothing else is left.
    var collapsed: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
