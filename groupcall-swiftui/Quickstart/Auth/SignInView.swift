//
//  SignInView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// Signs in with an application ID, a user ID and an optional access token.
struct SignInView: View {
    @State private var input = SignInInput()
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            Image("icSendbird")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding(.top, 92)
            Text("Sendbird Calls")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)
            VStack(spacing: 16) {
                InputField(placeholder: "Application ID", text: $input.appId)
                InputField(placeholder: "User ID", text: $input.userId)
                InputField(placeholder: "Access token (optional)", text: $input.accessToken)
            }
            .padding(.top, 34)
            Button("Sign in") { signIn() }
                .buttonStyle(FilledButtonStyle(height: 60, titleColor: Theme.signInButtonTitle))
                .disabled(isSigningIn)
                .padding(.top, 32)
            Spacer()
            Text(AppInfo.versionDescription)
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .background(.white)
        .overlay {
            if isSigningIn { ProgressView() }
        }
        .errorAlert($errorMessage)
    }

    private func signIn() {
        let credential: SignInCredential
        do {
            credential = try input.validated()
        } catch {
            errorMessage = error.localizedDescription
            return
        }
        isSigningIn = true
        Task {
            defer { isSigningIn = false }
            do {
                try await AuthService.shared.signIn(credential)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
