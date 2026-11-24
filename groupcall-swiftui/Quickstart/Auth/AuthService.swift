//
//  AuthService.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation
import Observation
import SendBirdCalls

/// Signs the user in to and out of Sendbird Calls.
///
/// Like the UIKit sample, this sample doesn't keep the user signed in after the app quits.
@MainActor
@Observable
final class AuthService {
    static let shared = AuthService()

    /// The signed-in user, or `nil` while signed out.
    private(set) var currentUser: User?

    var isSignedIn: Bool { currentUser != nil }

    func signIn(_ credential: SignInCredential) async throws {
        // The app ID comes from the sign-in screen, so configure Sendbird Calls with it every time.
        SendBirdCall.configure(appId: credential.appId)

        let params = AuthenticateParams(userId: credential.userId, accessToken: credential.accessToken)
        currentUser = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<User, Error>) in
            SendBirdCall.authenticate(with: params) { user, error in
                if let user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: error ?? AuthError.failed)
                }
            }
        }
    }

    func signOut() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            // Sign out locally even when the request fails, as the UIKit sample does.
            SendBirdCall.deauthenticate { _ in continuation.resume() }
        }
        currentUser = nil
    }
}

enum AuthError: LocalizedError {
    case failed

    var errorDescription: String? { "Failed to authenticate" }
}
