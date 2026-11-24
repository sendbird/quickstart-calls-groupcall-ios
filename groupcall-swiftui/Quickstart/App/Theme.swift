//
//  Theme.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// Colors and styles shared with the UIKit sample (`groupcall-uikit`), so that both samples look the same.
enum Theme {
    // The storyboards of the UIKit sample define some colors in the Generic RGB color space ("calibratedRGB"),
    // which UIKit renders differently from the same numbers in sRGB. The values below are what the UIKit sample shows.

    /// #7B53EF in the Display P3 color space. Borders of text fields and the tint of navigation bars.
    static let purple = Color(.displayP3, red: 123 / 255, green: 83 / 255, blue: 239 / 255)
    /// #742EDD in Generic RGB, shown as #884DE4. Filled buttons and the title of the "Enter" button.
    static let buttonPurple = Color(red: 136 / 255, green: 77 / 255, blue: 228 / 255)
    /// #F6F8FC in Display P3. The title of the "Sign in" button.
    static let signInButtonTitle = Color(.displayP3, red: 246 / 255, green: 248 / 255, blue: 252 / 255)
    /// #F0F0F0 in Generic RGB, shown as #F3F3F3.
    static let fieldBackground = Color(red: 243 / 255, green: 243 / 255, blue: 243 / 255)
    /// #EEEEEE in Generic RGB, shown as #F1F1F1. Behind the cards of the main screen.
    static let mainBackground = Color(red: 241 / 255, green: 241 / 255, blue: 241 / 255)
    /// #7351E9 in Display P3. The "Enter" button of the preview screen.
    static let enterButton = Color(.displayP3, red: 115 / 255, green: 81 / 255, blue: 233 / 255)
    /// #2C2C2C. Behind the participants of the room screen.
    static let roomBackground = Color(red: 44 / 255, green: 44 / 255, blue: 44 / 255)
    /// #2C2C2C in Generic RGB, shown as #3A3A3A. Behind a participant without video.
    static let tileBackground = Color(red: 58 / 255, green: 58 / 255, blue: 58 / 255)
    /// #BDBDBD in Generic RGB, shown as #C9C9C9. The circle behind the room icon of the room screen.
    static let roomIconBackground = Color(red: 201 / 255, green: 201 / 255, blue: 201 / 255)
    static let divider = Color.black.opacity(0.12)
    static let primaryText = Color.black.opacity(0.88)
    static let secondaryText = Color.black.opacity(0.5)
}

/// A purple button that fills the width, like "Sign in" and "Create".
struct FilledButtonStyle: ButtonStyle {
    var height: CGFloat
    /// `Theme.signInButtonTitle` on the sign-in screen, white on the main screen.
    var titleColor: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(titleColor)
            .frame(maxWidth: .infinity, minHeight: height)
            .background(Theme.buttonPurple, in: RoundedRectangle(cornerRadius: 4))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// A gray text field that shows a purple border while editing.
struct InputField: View {
    let placeholder: String
    @Binding var text: String
    /// Space on the trailing side, for a button over the field.
    var trailingInset: CGFloat = 0

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 17))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isFocused)
            .padding(.leading, 16)
            .padding(.trailing, 16 + trailingInset)
            .frame(height: 56)
            .background(Theme.fieldBackground, in: RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.purple, lineWidth: isFocused ? 1 : 0))
    }
}

extension View {
    /// Shows an alert titled "Error" with a "Done" button while `message` is set.
    func errorAlert(_ message: Binding<String?>) -> some View {
        alert("Error", isPresented: Binding(get: { message.wrappedValue != nil }, set: { if !$0 { message.wrappedValue = nil } })) {
            Button("Done", role: .cancel) { }
        } message: {
            Text(message.wrappedValue ?? "")
        }
    }
}
