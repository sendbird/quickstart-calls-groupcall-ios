//
//  PreviewView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// Shows the camera and lets the user turn off the microphone or the camera before entering a room.
struct PreviewView: View {
    let room: Room
    /// Called after the user entered the room.
    let onEnter: (Room) -> Void

    // `SwiftUI.State`, not `State`: see `MainView`.
    @SwiftUI.State private var isAudioMuted = false
    @SwiftUI.State private var isVideoOff = false
    @SwiftUI.State private var isEntering = false
    @SwiftUI.State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Color(uiColor: .systemGray3)
                    // Remove the preview to turn the camera off, as the UIKit sample does.
                    // Also stop it while entering, so that Sendbird Calls can use the camera.
                    if !isVideoOff && !isEntering {
                        CameraPreview()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.top, 24)
                checkbox("Mute my audio", isOn: $isAudioMuted)
                    .padding(.top, 16)
                checkbox("Turn off my video", isOn: $isVideoOff)
                    .padding(.top, 14)
                Button { enter() } label: {
                    Text("Enter")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Theme.enterButton, in: RoundedRectangle(cornerRadius: 4))
                }
                .disabled(isEntering)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
            .background(.white)
            .navigationTitle("Enter room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .errorAlert($errorMessage)
        }
        .tint(Theme.purple)
    }

    private func checkbox(_ title: String, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(isOn.wrappedValue ? "iconCheckboxOn" : "iconCheckboxOff")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(.plain)
    }

    private func enter() {
        isEntering = true
        Task {
            do {
                try await RoomService.enter(room, isAudioEnabled: !isAudioMuted, isVideoEnabled: !isVideoOff)
                onEnter(room)
            } catch {
                isEntering = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
