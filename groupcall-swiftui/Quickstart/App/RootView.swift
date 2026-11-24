//
//  RootView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// Shows the sign-in screen or the main tabs, depending on whether a user is signed in.
struct RootView: View {
    private var auth: AuthService { .shared }

    var body: some View {
        if auth.isSignedIn {
            MainTabView()
        } else {
            SignInView()
        }
    }
}
